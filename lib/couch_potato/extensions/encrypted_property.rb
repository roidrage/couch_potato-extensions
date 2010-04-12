require 'bcrypt'

module CouchPotato
  module Extensions
    class EncryptedProperty
      attr_reader :type, :name
      
      def initialize(owner, name, options = {})
        @type = owner
        @name = name
        @options = options
        
        define_accessors(name)
      end
      
      def define_accessors(name)
        type.class_eval do
          define_method(name) do
            instance_variable_get("@#{name}")
          end
          
          define_method("#{name}=") do |value|
            instance_variable_set("@#{name}", value)
          end
        end
      end

      def build(object, json)
        value = json[name.to_s].nil? ? json[name.to_sym] : json[name.to_s]
        object.send "#{name}=", decrypt(value)
      end

      def dirty?(object)
        false
      end
      
      def serialize(json, object)
        json[name] = encrypt(object.send(name))
      end
      
      def encrypt(value)
        Base64.encode64(EzCrypto::Key.encrypt_with_password(@options[:password], @options[:salt], value)) if not value.nil?
      end
      
      def decrypt(value)
        EzCrypto::Key.decrypt_with_password(@options[:password], @options[:salt], Base64.decode64(value))
      end
    end
  end
end
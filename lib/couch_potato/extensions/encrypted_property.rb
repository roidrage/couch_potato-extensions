require 'bcrypt'

module CouchPotato
  module Extensions
    class EncryptedProperty < CouchPotato::Persistence::SimpleProperty
      def initialize(owner_clazz, name, options = {})
        super
        @options = options
      end
      
      def build(object, json)
        value = json[name.to_s].nil? ? json[name.to_sym] : json[name.to_s]
        object.send "#{name}=", decrypt(value)
        object.instance_variable_set("@encrypted_#{name}", value)
      end

      def dirty?(object)
        object.send("#{name}_changed?")
      end
      
      def serialize(json, object)
        if dirty?(object) or encrypted_value(object).nil?
          json[name] = encrypt(object.send(name))
        else
          json[name] = encrypted_value(object)
        end
      end

      def value(result, object)
        result[name] = object.send(name)
      end
      
      def encrypt(value)
        Base64.encode64(EzCrypto::Key.encrypt_with_password(@options[:password], @options[:salt], value))
      end
      
      def decrypt(value)
        EzCrypto::Key.decrypt_with_password(@options[:password], @options[:salt], Base64.decode64(value))
      end
      
      def encrypted_value(object)
        object.instance_variable_get("@encrypted_#{name}")
      end
    end
  end
end
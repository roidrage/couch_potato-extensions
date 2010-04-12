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
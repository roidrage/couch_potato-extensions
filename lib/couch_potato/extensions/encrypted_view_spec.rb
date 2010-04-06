module CouchPotato
  module Extensions
    class EncryptedViewSpec < CouchPotato::View::ModelViewSpec
      
      def view_parameters
        parameters = super
        if parameters[:key]
          parameters[:key] = find_and_encrypt_key_attribute(parameters[:key])
        end
        parameters
      end
      
      def find_and_encrypt_key_attribute(key)
        property = klass.properties.find{|property| property.name.to_s == options[:key].to_s}
        return key if not property
        property.encrypt(key)
      end
    end
  end
end
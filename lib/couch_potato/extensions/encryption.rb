require 'ezcrypto'

module CouchPotato
  module Persistence
    module Properties
      module ClassMethods
        def encrypted_property(name, options = {})
          properties << CouchPotato::Extensions::EncryptedProperty.new(self, name, options)
        end
      end
    end
  end
end

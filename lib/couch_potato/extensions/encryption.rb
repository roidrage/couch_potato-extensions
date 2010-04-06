require 'ezcrypto'

module CouchPotato
  module Extensions
    module Encryption
      def self.included(base)
        base.instance_eval do
          def encrypted_property(name, options = {})
            properties << CouchPotato::Extensions::EncryptedProperty.new(self, name, options)
          end
        end
      end
    end
  end
end

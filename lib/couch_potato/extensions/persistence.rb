module CouchPotato
  module Persistence
    def attributes
      self.class.properties.inject({}) do |result, property|
        result[property.name] = send(property.name)
        result
      end
    end
  end
end
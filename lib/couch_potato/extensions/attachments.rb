module CouchPotato
  module Extensions
    module Attachments
      def attachment(name)
        if not new?
          begin
            CouchPotato.database.send(:database).fetch_attachment(id, name)
          rescue RestClient::ResourceNotFound
          end
        end
      end
    end
  end
end

CouchPotato::Persistence.send(:include, CouchPotato::Extensions::Attachments)

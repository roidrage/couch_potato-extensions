require File.expand_path(File.dirname(__FILE__) + "/extensions/persistence")
require File.expand_path(File.dirname(__FILE__) + "/extensions/encryption")
require File.expand_path(File.dirname(__FILE__) + "/extensions/encrypted_property")
require File.expand_path(File.dirname(__FILE__) + "/extensions/encrypted_view_spec")
require File.expand_path(File.dirname(__FILE__) + "/extensions/attachments")

module CouchPotato
  module Extensions
    VERSION = '0.0.7'
  end
end

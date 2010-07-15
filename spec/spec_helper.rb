require 'rubygems'
require 'spec'
require 'couch_potato'

$:.unshift(File.expand_path(File.dirname(__FILE__) + "../lib"))

CouchPotato::Config.database_name = 'couch_potato-extentions_test'
def recreate_db
  CouchPotato.couchrest_database.recreate!
end
recreate_db


require 'couch_potato/extensions/encryption'
require 'couch_potato/extensions/encrypted_property'
require 'couch_potato/extensions/persistence'
require 'couch_potato/extensions/encrypted_view_spec'
require 'couch_potato/extensions/attachments'

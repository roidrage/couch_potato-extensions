require 'spec_helper'

describe CouchPotato::Extensions::EncryptedProperty do
  class SecureDocument
    include CouchPotato::Persistence
    include CouchPotato::Extensions::Encryption
    encrypted_property :body, :salt => 'Va7JYeT7t08vMweYU6F6dO', :password => "coffee! more coffee!"
  end
  
  describe "setting up" do
    it "should add the declared property to the internal list" do
      SecureDocument.properties.find()
    end
  end
  
  describe "accessing attributes" do
    it "should add attribute accessors" do
      document = SecureDocument.new
      document.respond_to?(:body).should == true
      document.respond_to?(:body=).should == true
    end
    
    it "should set the attribute" do
      document = SecureDocument.new(:body => "very important")
      document.body.should == 'very important'
    end
  end
  
  describe "saving documents" do
    let(:document) { SecureDocument.new(:body => "very important") }

    it "should encrypt the property when accessing the document hash" do
      body = document.to_hash[:body]
      body.should_not == nil
      body.should_not == 'very important'
      body.should == Base64.encode64(EzCrypto::Key.encrypt_with_password("coffee! more coffee!", "Va7JYeT7t08vMweYU6F6dO", "very important"))
    end
  end
  
  describe "loading documents" do
    let(:document) { SecureDocument.new(:body => "very important") } 
    
    it "should decrypt the attributes" do
      CouchPotato.database.save_document document
      loaded_document = CouchPotato.database.load_document(document.id)
      loaded_document.body.should == "very important"
    end
  end
end
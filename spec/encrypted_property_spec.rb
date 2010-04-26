require 'spec_helper'

describe CouchPotato::Extensions::EncryptedProperty do
  class SecureDocument
    include CouchPotato::Persistence
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
    
    it "should allow access through the attributes hash" do
      document = SecureDocument.new(:body => "very important")
      document.attributes[:body].should == "very important"
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
    
    it "should not encrypt an attribute that hasn't changed" do
      @document = document
      CouchPotato.database.save_document document
      @document = CouchPotato.database.load_document(document.id)
      @document.is_dirty
      EzCrypto::Key.should_not_receive(:encrypt_with_password)
      CouchPotato.database.save_document @document
    end
    
    describe "with nil'd properties" do
      before do
        @document = SecureDocument.new(:body => nil)
      end
      
      it "should not fail when saving" do
        lambda do
          CouchPotato.database.save_document @document
        end.should_not raise_error
      end
      
      it "should return nil when loading" do
        CouchPotato.database.save_document @document
        @document = CouchPotato.database.load_document(@document.id)
        @document.body.should == nil
      end
    end
  end
  
  describe "loading documents" do
    let(:document) do
      document = SecureDocument.new(:body => "very important")
      CouchPotato.database.save_document document
      CouchPotato.database.load_document(document.id)
    end
    
    it "should decrypt the attributes" do
      document.body.should == "very important"
    end
    
    it "should not encrypt the data when it was changed" do
      document.instance_variable_get(:@encrypted_body).should_not == nil
    end
  end

end
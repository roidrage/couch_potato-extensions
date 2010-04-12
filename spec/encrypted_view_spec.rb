require 'spec_helper'

describe CouchPotato::Extensions::EncryptedViewSpec do
  class SecureUser
    include CouchPotato::Persistence
    encrypted_property :email, :salt => 'Va7JYeT7t08vMweYU6F6dO', :password => "coffee! more coffee!"
    
    view :by_email, :key => :email, :type => CouchPotato::Extensions::EncryptedViewSpec
  end
  
  before(:each) do
    @encrypted_email = Base64.encode64(EzCrypto::Key.encrypt_with_password("coffee! more coffee!", "Va7JYeT7t08vMweYU6F6dO", "paul@example.com"))
  end
  
  let(:user) do
    user = SecureUser.new(:email => "paul@example.com")
    CouchPotato.database.save_document(user)
    user
  end
  
  it "should encrypt the key before running the view" do
    CouchPotato.database.send(:database).should_receive(:view) do |url, parameters|
      parameters[:key].should == @encrypted_email
      {"rows" => {}}
    end
    
    CouchPotato.database.view(SecureUser.by_email(:key => 'paul@example.com'))
  end
  
  it "should find documents with an encrypted email" do
    user
    results = CouchPotato.database.view(SecureUser.by_email(:key => 'paul@example.com'))
    results.first.should == user
  end
end
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CouchPotato::Extensions::Attachments do
  class Attachment
    include CouchPotato::Persistence
  end

  it "should add an accessor for attachments" do
    Attachment.new.respond_to?(:attachment).should == true
  end

  it "should fetch the attachment when available" do
    attachment = Attachment.new
    attachment._attachments['pdf'] = {'data' => 'invoice', 'content_type' => 'application/pdf'}
    CouchPotato.database.save(attachment)
    attachment.attachment('pdf').should == 'invoice'
  end

  it "should not raise an error when the record is not persisted yet" do
    attachment = Attachment.new
    lambda {
      attachment.attachment('pdf').should == nil
    }.should_not raise_error
  end

  it "should return nil when the attachment is not available" do
    attachment = Attachment.new
    CouchPotato.database.save(attachment)
    attachment.attachment('pdf').should == nil
  end
end

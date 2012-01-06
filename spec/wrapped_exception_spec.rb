require "spec_helper"

require "kcaco/wrapped_exception"

module Kcaco
  describe WrappedException do

    let(:boom) { Boom.new }
    let(:we) { WrappedException.new(boom.rescued) }

    
    it "should generate an we title" do
      we.title.should == "RuntimeError: exception"
    end

    it "should figure out the file name that caused the we" do
      we.filename.should == "boom.rb"
    end
    
    it "should figure out the line number that caused the we" do
      we.line_no.should == Boom.raise_line_no
    end

    it "should create a pretty version" do
      we.should_receive(:uuid).and_return("uuid")
      we.pretty.should == "uuid RuntimeError: exception [boom.rb L10]"
    end

    it "should make a uuid" do
      uuid = we.uuid
      we.uuid.should =~ /[a-z0-9\-]+/
      we.uuid.should == uuid
    end
  end
end

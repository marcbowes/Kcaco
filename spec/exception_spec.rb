require "spec_helper"

require "kcaco/exception"

module Kcaco
  describe Exception do

    let(:boom) { Boom.new }
    let(:exception) { Exception.new(boom.rescued) }

    
    it "should generate an exception title" do
      exception.title.should == "RuntimeError: exception"
    end

    it "should figure out the file name that caused the exception" do
      exception.filename.should == "boom.rb"
    end
    
    it "should figure out the line number that caused the exception" do
      exception.line_no.should == Boom.raise_line_no
    end
  end
end

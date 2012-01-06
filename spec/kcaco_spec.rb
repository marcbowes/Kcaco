require "spec_helper"

require "kcaco"

describe Kcaco do

  let(:boom) { Boom.new }
  
  it "should generate an exception title" do
    exception = boom.create
    Kcaco.exception_title(exception).should ==
      "RuntimeError: exception"
  end

  it "should figure out the line number that caused the exception" do
    exception = boom.rescued
    Kcaco.exception_filename_and_line_no(exception).should == ["boom.rb", Boom.raise_line_no]
  end

  it "should create a pretty log entry" do
    exception = boom.rescued
    Kcaco.pretty(exception).should == "RuntimeError: exception [boom.rb L10]"
  end
end

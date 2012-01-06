require "spec_helper"

require "kcaco"

describe Kcaco do

  let(:boom) { Boom.new }
  
  it "should generate an exception title" do
    exception = boom.create
    Kcaco.exception_title(exception).should ==
      "RuntimeError: exception"
  end

  it "should figure out the line number from a backtrace line" do
    line = "/home/user/projects/kcaco/spec/support/boom.rb:10:in `raise'"
    Kcaco.line_no_from_backtrace_line(line).should == 10
  end

  it "should figure out the line number that caused the exception" do
    exception = boom.rescued
    Kcaco.exception_line(exception).should == Boom.raise_line_no
  end
end

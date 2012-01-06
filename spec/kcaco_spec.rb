require "spec_helper"

require "kcaco"

describe Kcaco do

  let(:boom) { Boom.new }
  
  it "should create a pretty log entry" do
    exception = boom.rescued
    Kcaco.pretty(exception).should == "RuntimeError: exception [boom.rb L10]"
  end
end

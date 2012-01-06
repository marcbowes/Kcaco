require "spec_helper"

require "kcaco"

describe Kcaco do

  let(:boom) { Boom.new }

  before do
    Kcaco.auto_save = false
  end
  
  it "should create a pretty log entry" do
    exception = boom.rescued
    rest = Regexp.escape("RuntimeError: exception [boom.rb L10]")
    Kcaco.pretty(exception).should =~ /[a-z0-9\-]+ #{rest}/
  end
end

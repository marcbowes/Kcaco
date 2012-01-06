require "spec_helper"

require "kcaco"

describe Kcaco do

  before do
    Kcaco.auto_save = false
  end

  
  let(:boom) { Boom.new }
  let(:exception) { boom.rescued }


  it "should create a pretty log entry" do
    rest = Regexp.escape("RuntimeError: exception [boom.rb L10]")
    Kcaco.pretty(exception).should =~ /[a-z0-9\-]+ #{rest}/
  end

  it "should allow the title to be overridden" do
    Kcaco.pretty(exception, "title").should =~ /[a-z0-9\-]+ title/
  end
end

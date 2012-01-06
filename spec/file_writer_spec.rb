require "spec_helper"

require "fileutils"
require "kcaco/wrapped_exception"
require "kcaco/file_writer"

module Kcaco
  describe Exception do

    let(:boom) { Boom.new }
    let(:wrapped_exception) { WrappedException.new(boom.rescued) }
    let(:fw) { FileWriter.new(wrapped_exception) }

    
    it "should save the exception" do
      path = File.join("/tmp", [File.basename(__FILE__), Process.pid.to_s].join("-"))
      begin
        fw.save(path)
      ensure
        FileUtils.rm(path)
      end

      # Kind of difficult to test the content of this file because of
      # times and paths.
    end
  end
end

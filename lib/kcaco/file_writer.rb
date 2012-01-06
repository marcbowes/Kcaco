module Kcaco
  class FileWriter

    require "time"
    require "fileutils"
    require "yaml"

    
    attr_accessor :exception
    
    def initialize(exception)
      self.exception = exception
    end


    def save(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, "w") do |f|
        [
         ["time", Time.now.iso8601],
         ["type", exception.type],
         ["message", exception.message],
        ].each do |label, text|
          f.puts([label, text].join(": "))
        end

        f.puts("backtrace:")
        exception.backtrace.each do |line|
          f.puts(line)
        end

        f.puts
        f.puts(exception.to_yaml)
      end
    end
  end
end

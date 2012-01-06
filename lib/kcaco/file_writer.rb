module Kcaco
  class FileWriter

    require "time"
    require "fileutils"
    require "yaml"

    
    attr_accessor :exception
    
    def initialize(exception)
      self.exception = exception
    end


    def wrapped_hash
      {
        "time" => Time.now.iso8601,
        "title" => exception.title,
        "type" => exception.type,
        "message" => exception.message,
        "payload" => exception.payload,
        "backtrace" => exception.backtrace,
      }
    end
    
    def save(path)
      FileUtils.mkdir_p(File.dirname(path))
      File.open(path, "w") do |f|
        f.puts(wrapped_hash.to_yaml)
        f.puts
        f.puts(exception.to_yaml)
      end
    end
  end
end

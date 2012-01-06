module Kcaco
  class WrappedException

    require "guid"

    
    attr_accessor :exception, :title, :payload
    
    def initialize(exception, title = nil)
      self.exception = exception
      self.title = title || title_from_exception
    end


    def type
      exception.class.name
    end
    
    def message
      exception.message
    end
    
    def backtrace
      exception.backtrace
    end
    
    def to_yaml
      exception.to_yaml
    end
    
    def extract_filename_and_line_no(line)
      if (m = line.match(/(.+):(\d+):/))
        [File.basename(m[1]), m[2].to_i]
      end
    end

    def filename_and_line_no
      @filename_and_line_no ||= 
        extract_filename_and_line_no(backtrace.first)
    end

    def filename
      filename_and_line_no.first
    end

    def line_no
      filename_and_line_no.last
    end
    
    def title_from_exception
      [type, message].join(": ")
    end

    def pretty
      [
       uuid,
       title,
       "[%s L%i]" % [filename, line_no],
      ].join(" ")
    end

    def uuid
      @uuid ||= Guid.new.to_s
    end
  end
end

module Kcaco
  class Exception

    attr_accessor :exception
    
    def initialize(exception)
      self.exception = exception
    end


    def extract_filename_and_line_no(line)
      if (m = line.match(/(.+):(\d+):/))
        [File.basename(m[1]), m[2].to_i]
      end
    end

    def filename_and_line_no
      @filename_and_line_no ||= 
        extract_filename_and_line_no(exception.backtrace.first)
    end

    def filename
      @filename ||= filename_and_line_no.first
    end

    def line_no
      @line_no ||= filename_and_line_no.last
    end
    
    def title
      [
       exception.class.name,
       exception.message,
      ].join(": ")
    end

    def pretty
      [
       title,
       "[%s L%i]" % [filename, line_no],
      ].join(" ")
    end
  end
end

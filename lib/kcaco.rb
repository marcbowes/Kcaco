require "kcaco/version"

module Kcaco

  class << self

    def extract_filename_and_line_no(line)
      if (m = line.match(/(.+):(\d+):/))
        [File.basename(m[1]), m[2].to_i]
      end
    end

    def exception_filename_and_line_no(exception)
      line = exception.backtrace.first
      extract_filename_and_line_no(line)
    end
    
    def exception_title(exception)
      [
       exception.class.name,
       exception.message,
      ].join(": ")
    end

    def pretty(exception)
      filename, line_no = exception_filename_and_line_no(exception)
      [
       exception_title(exception),
       "[%s L%i]" % [filename, line_no],
      ].join(" ")
    end
  end
end

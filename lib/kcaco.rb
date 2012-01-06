require "kcaco/version"

module Kcaco

  class << self

    def line_no_from_backtrace_line(line)
      if (m = line.match(/:(\d+):/))
        m[1].to_i
      end
    end

    def exception_line(exception)
      line_no_from_backtrace_line(exception.backtrace.first)
    end
    
    def exception_title(exception)
      [
       exception.class.name,
       exception.message,
      ].join(": ")
    end
  end
end

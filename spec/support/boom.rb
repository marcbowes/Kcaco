class Boom
  
  DEFAULT_MESSAGE = "exception"

  def create(message = DEFAULT_MESSAGE)
    RuntimeError.new(message)
  end

  def raise(message = DEFAULT_MESSAGE)
    Kernel.raise(create(message))
  end
  
  def rescued(message = DEFAULT_MESSAGE)
    begin
      self.raise
    rescue RuntimeError => e
      e
    end
  end

  class << self
    
    def raise_line_no
      @raise_line_no ||= get_raise_line_no
    end

    def get_raise_line_no
      File.open(__FILE__, "r") do |f|
        f.each do |line|
          return f.lineno if line.include?("Kernel.raise")
        end
      end
      nil
    end
  end
end

require "kcaco/version"

module Kcaco

  class << self

    def exception_title(exception)
      [
       exception.class.name,
       exception.message,
      ].join(": ")
    end
  end
end

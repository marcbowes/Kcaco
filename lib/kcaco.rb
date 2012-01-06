require "kcaco/version"
require "kcaco/exception"

module Kcaco

  class << self

    def pretty(exception)
      Kcaco::Exception.new(exception).pretty
    end
  end
end

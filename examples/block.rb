#!/usr/bin/env ruby

require "logger"
require "kcaco"

class MichaelBay

  class Boom < RuntimeError; end
  
  def explosions
    raise Boom.new("ba da bloom")
  end
end

if __FILE__ == $0
  logger = Logger.new(STDOUT)
  begin
    MichaelBay.new.explosions
  rescue => e
    logger.error Kcaco.pretty(e) { "custom payload" }
  end
end

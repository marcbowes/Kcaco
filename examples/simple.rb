#!/usr/bin/env ruby

require "kcaco"

class MichaelBay

  class Boom < RuntimeError; end
  
  def explosions
    raise Boom.new("ba da bloom")
  end
end

if __FILE__ == $0
  begin
    MichaelBay.new.explosions
  rescue => e
    STDOUT.puts Kcaco.pretty(e)
  end
end

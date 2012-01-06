require "kcaco/version"
require "kcaco/wrapped_exception"
require "kcaco/file_writer"

module Kcaco

  class << self

    def auto_save=(bool)
      @auto_save = bool
    end
    
    def auto_save?
      @auto_save != false
    end

    def save_path=(path)
      @save_path = path
    end

    def save_path(wrapped_exception = nil)
      @save_path ||= "/tmp/kcaco/exceptions"
      if wrapped_exception
        File.join(@save_path, wrapped_exception.uuid)
      else
        @save_path
      end
    end

    def save(wrapped_exception)
      Kcaco::FileWriter.new(wrapped_exception).
        save(save_path(wrapped_exception))
    end
    
    def pretty(exception)
      wrapped_exception = Kcaco::WrappedException.new(exception)
      save(wrapped_exception) if auto_save?
      wrapped_exception.pretty
    end
  end
end

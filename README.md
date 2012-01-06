# Keep Calm and Carry On

## Synopsis

Ever written a long running process before? Ever had it raise
and exception and die? Ever wrapped your main loop in a
`begin..rescue` so you can just Keep Calm and Carry On? Ever found it
really annoying that logging the damn thing is so difficult?

Kcaco helps by providing some helper functions around dealing with
exceptions. Specifically with regards to logging the bastard so you
can deal with it. Example:

    require "kcaco"
    begin
      raise RuntimeError.new("Goodbye, cruel world")
    rescue => e
      puts Kcaco.pretty(e)
    end

This will print out a line like so:
`a84aedf9-8cda-13dd-123f-c8572078ea90 RuntimeError: Goodbye, cruel
world [(irb) L3]`. In case it's not obvious, the output contains a
GUID, the class of the error and the filename and linenumber it
occured on. In a single line ideal for logging.

## Why?

Long running processes (daemons) tend to err on the side of logging
exceptions and carrying on. This is peachy, but there are some things
you definitely want to do. Without a catch-all `begin..rescue`, your
application might do this:

    irb> raise RuntimeError.new("death")
    RuntimeError: death
            from (irb):1

That's pretty useful. Right?

In a daemon, its natural to want just as much information. Except you
will want to use a logger - especially at the appropriate level. You
may write something like this to get similar output in your logs:

    begin
      # ...
    rescue => e
      logger.error "#{e.class.name}: #{e.message}"
    end

But now you don't know where the error came from (backtrace line #1)
or actually anything else from the backtrace. You can extend the code
with something like:

    e.backtrace.each do |line| logger.error(line); end

But now you've done something horrible: if you `grep ERROR` in your
log file, the number of lines returned is no longer the number of
errors in your log. There are a bunch of ways around this:

* Log the entire backtrace on 1 line, e.g. using `"#{e.class.name}:
  #{e.message}" #{e.backtrace.inspect}`. This gives you ugly logs.
* Log the backtrace at a different level, e.g. `DEBUG`. This means you
  have to run with verbose logging.
* Add additional smarts.

Kcaco is the additional smarts. Quite simply what it does is:

* Save you having to format the log message by doing it for you.
* Write more detail to a separate file where you can inspect it later.

## Usage

    require "kcaco"
    # in a rescue block, instead of the manual work:
    logger.error Kcaco.pretty(exception)

This will print out a message to your logs in the format: `GUID
ExceptionClass: the message [filename.rb L123]`. Additionally, it will
write out the exception object to `Kcaco.save_path` in a file named
the same as that GUID. You can disable the save behavior with
`Kcaco.auto_save = false`.

## Example

    $ bundle exec examples/simple.rb
    900308c3-16ac-2803-ac97-db64464baae8 MichaelBay::Boom: ba da bloom [simple.rb L10]
    
    cat /tmp/kcaco/exceptions/900308c3-16ac-2803-ac97-db64464baae8 
    time: 2012-01-06T16:01:53+02:00
    type: MichaelBay::Boom
    message: ba da bloom
    backtrace:
    examples/simple.rb:10:in `explosions'
    examples/simple.rb:16
    
    --- !ruby/exception:MichaelBay::Boom 
    message: ba da bloom
# Keep Calm and Carry On

## Synopsis

Ever written a long running process before? Ever had it raise
and exception and die? Ever wrapped your main loop in a
`begin..rescue` so you can just Keep Calm and Carry On? Ever found it
really annoying that logging the damn thing is so difficult?

Kcaco helps by providing some helper functions around dealing with
exceptions. Specifically with regards to logging the bastard so you
can deal with it. Example:

``` ruby
require "kcaco"
begin
  raise RuntimeError.new("Goodbye, cruel world")
rescue => e
  puts Kcaco.pretty(e)
end
```

This will print out a line like so:
`a84aedf9-8cda-13dd-123f-c8572078ea90 RuntimeError: Goodbye, cruel
world [(irb) L3]`. In case it's not obvious, the output contains a
GUID, the class of the error and the filename and linenumber it
occured on. In a single line ideal for logging. Additionally, we
serialize the exception to disk (hence the GUID - the filename we save
it too) so you can look at it later.

## Usage

``` ruby
require "kcaco"
# in a rescue block, instead of the manual work:
logger.error Kcaco.pretty(exception)
```

This will print out a message to your logs in the format: `GUID
ExceptionClass: the message [filename.rb L123]`. Additionally, it will
write out the exception object to `Kcaco.save_path` in a file named
the same as that GUID. You can disable the save behavior with
`Kcaco.auto_save = false`.

### Payloads

If you have additional information to store, you can do so by parsing
in a payload with the block syntax (`examples/block.rb`).

```ruby
Kcaco.pretty(exception) { "payload" }
```

This will not affect the logged message but will write out the payload
in the saved exception. This can be useful if you want to store
state. For example, if your application is processing a queue and you
got an exception, you could store the queue message that triggered the
error in the payload for later debugging.

### Customize log message

TBD.

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

``` ruby
begin
  # ...
rescue => e
  logger.error "#{e.class.name}: #{e.message}"
end
```

But now you don't know where the error came from (backtrace line #1)
or actually anything else from the backtrace. You can extend the code
with something like:

``` ruby
e.backtrace.each do |line| logger.error(line); end
```

But now you've done something horrible: if you `grep ERROR` in your
log file, the number of lines returned is no longer the number of
errors in your log. There are a bunch of ways around this:

Log the entire backtrace on 1 line, This gives you ugly logs
especially with long backtraces. For example:

    $ bundle exec examples/no_kcaco_one_line.rb
    E, [2012-01-06T16:26:27.705513 #647] ERROR -- : MichaelBay::Boom: ba da bloom ["examples/no_kcaco_one_line.rb:10:in `explosions'", "examples/no_kcaco_one_line.rb:17"]

Log the backtrace at a different level, e.g. `DEBUG`. This means you
have to run with verbose logging:

    $ bundle exec examples/no_kcaco_different_levels.rb
    E, [2012-01-06T16:28:33.903684 #736] ERROR -- : MichaelBay::Boom: ba da bloom
    D, [2012-01-06T16:28:33.903784 #736] DEBUG -- : examples/no_kcaco_different_levels.rb:10:in `explosions'
    D, [2012-01-06T16:28:33.903814 #736] DEBUG -- : examples/no_kcaco_different_levels.rb:17
    
Or you can roll your own smarts. Repeatedly. Or just use something
like Kcaco. Quite simply what it does is:

* Save you having to format the log message by doing it for you.
* Write more detail to a separate file where you can inspect it later.

.. and you get

    $ bundle exec examples/simple.rb
    E, [2012-01-06T16:29:50.730922 #793] ERROR -- : ae58d80f-4bc3-899a-fd0b-2c831833510c MichaelBay::Boom: ba da bloom [simple.rb L11]

In this example, you could see the saved exception
`ae58d80f-4bc3-899a-fd0b-2c831833510c` on disk to get the full backtrace.

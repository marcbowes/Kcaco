# -*- encoding: utf-8 -*-
require File.expand_path('../lib/kcaco/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marc Bowes"]
  gem.email         = ["marcbowes@gmail.com"]
  gem.description   = %q{Helpers for dealing with exceptions}
  gem.summary       = %q{Bored of writing out exceptions to logs?}
  gem.homepage      = ""

  gem.files         = Dir["**/*"]
  gem.test_files    = Dir["spec/**/*"]
  gem.name          = "kcaco"
  gem.require_paths = ["lib"]
  gem.version       = Kcaco.version

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec")
end

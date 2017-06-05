# -*- encoding: utf-8 -*-
require File.expand_path('../lib/twtest/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Nicholas E. Rabenau"]
  gem.email         = ["nerab@gmx.net"]
  gem.description   = %q{Provides helpers for writing TaskWarrior integration tests in Ruby}
  gem.summary       = %q{Helpers for writing TaskWarrior tests in Ruby}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "twtest"
  gem.require_paths = ["lib"]
  gem.version       = TaskWarrior::Test::Integration::VERSION

  gem.add_development_dependency 'guard-test'
  gem.add_development_dependency 'guard-bundler'
  gem.add_development_dependency 'rake'
end

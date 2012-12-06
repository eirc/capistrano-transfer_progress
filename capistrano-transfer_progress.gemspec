# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-transfer_progress/version'

Gem::Specification.new do |gem|
  gem.name          = "capistrano-transfer_progress"
  gem.version       = Capistrano::TransferProgress::VERSION
  gem.authors       = ["Eric Cohen", "Nikos Dimitrakopoulos"]
  gem.email         = ["eirc.eirc@gmail.com", "nospam@nikosd.com"]
  gem.description   = %q{Progress bars for capistrano transfers}
  gem.summary       = %q{Hooks on capistrano transfers and provides a callback that displays a progressbar with current transfer progress}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency 'capistrano', '~> 2.0'
  gem.add_runtime_dependency 'progressbar'
end

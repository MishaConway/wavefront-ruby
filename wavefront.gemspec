# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wavefront/version'

Gem::Specification.new do |gem|
  gem.name          = "wavefront"
  gem.version       = Wavefront::VERSION
  gem.authors       = ["Misha Conway"]
  gem.email         = ["MishaAConway@gmail.com"]
  gem.description   = %q{Wavefront parser and exporter}
  gem.summary       = %q{Wavefront parser and exporter}
  gem.homepage      = "https://github.com/MishaConway/wavefront-ruby"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end

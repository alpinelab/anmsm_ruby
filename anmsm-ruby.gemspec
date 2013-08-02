# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'anmsm/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "anmsm-ruby"
  spec.version       = Anmsm::Ruby::VERSION
  spec.authors       = ["Thibault Dalban", "Michael Baudino", "Lucas Biguet-Mermet"]
  spec.email         = ["thibault@alpine-lab.com", "michael@alpine-lab.com", "lucas@alpine-lab.com"]
  spec.description   = "The anmsm-ruby Gem gives you access to ANMSM API."
  spec.summary       = "Acces the ANMSM API."
  spec.homepage      = "https://github.com/alpinelab/anmsm-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ruby_odata", "~> 0.1.4"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'staccato/version'

Gem::Specification.new do |spec|
  spec.name          = "staccato"
  spec.version       = Staccato::VERSION
  spec.authors       = ["Tony Pitale"]
  spec.email         = ["tpitale@gmail.com"]
  spec.description   = "Ruby Google Analytics Measurement"
  spec.summary       = "Ruby Google Analytics Measurement"
  spec.homepage      = "https://github.com/tpitale/staccato"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", ">= 3.0.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "bourne"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "faraday"
end

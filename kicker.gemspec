# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kicker/version'

Gem::Specification.new do |spec|
  spec.name          = "kicker"
  spec.version       = Kicker::VERSION
  spec.authors       = ["Bartosz Kopinski"]
  spec.email         = ["bartosz@kopinski.pl"]
  spec.summary       = 'Automated RSpec tests generator'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_dependency "rspec"
end

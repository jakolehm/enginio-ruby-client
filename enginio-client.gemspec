# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enginio/client/version'

Gem::Specification.new do |spec|
  spec.name          = "enginio-client"
  spec.version       = Enginio::Client::VERSION
  spec.authors       = ["Jari Kolehmainen"]
  spec.email         = ["jari.kolehmainen@digia.com"]
  spec.description   = "A simple Ruby client for the engin.io REST API"
  spec.summary       = "A simple Ruby client for the engin.io REST API"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "httpclient", "~> 2.3"
end

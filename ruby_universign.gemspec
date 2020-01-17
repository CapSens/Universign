# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'universign/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_universign"
  spec.version       = Universign::VERSION
  spec.authors       = ["Nicolas Besnard", "Yassine Zenati", "Antoine Becquet"]
  spec.email         = ["besnard.nicolas@gmail.com", "yassine@capsens.eu", "antoine@capsens.eu"]

  spec.summary       = "Universign's API Wrapper"
  spec.description   = <<~EOF
    Ruby gem for interacting with Universign electronic signature API.
    It ease requests to Universign API, documents uploads and following signature state.
    This gem is *not* officialy made by Universign, but was originally created by CapSens for internal usage.
  EOF
  spec.homepage      = "https://github.com/CapSens/universign"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'activesupport', '>= 4.1'
  spec.add_runtime_dependency 'xmlrpc'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "dotenv", "~> 2.0"
  spec.add_development_dependency "webmock", "~> 3.0"
  spec.add_development_dependency "vcr", "~> 4.0"
end

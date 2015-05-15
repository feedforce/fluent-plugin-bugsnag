# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-bugsnag"
  spec.version       = '0.1.0'
  spec.authors       = ["koshigoe"]
  spec.email         = ["koshigoeb@gmail.com"]

  spec.summary       = %q{Fluentd output plubin for Bugsnag.}
  spec.description   = %q{Fluentd output plubin for Bugsnag.}
  spec.homepage      = "https://github.com/feedforce/fluent-plugin-bugsnag"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'webmock'

  spec.add_runtime_dependency 'fluentd'
end

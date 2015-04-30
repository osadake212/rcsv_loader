# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rcsv_loader/version'

Gem::Specification.new do |spec|
  spec.name          = "rcsv_loader"
  spec.version       = RCsvLoader::VERSION
  spec.authors       = ["osadake212"]
  spec.email         = ["osadake.212@gmail.com"]
  spec.summary       = %q{A simple csv loader.}
  spec.description   = %q{A simple csv loader.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '~> 4.2.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0.0"
end

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canvas_cc/version'

Gem::Specification.new do |spec|
  spec.name          = "canvas_cc"
  spec.version       = CanvasCc::VERSION
  spec.authors       = ["Instructure"]
  spec.email         = ["pseng@instructure.com"]
  spec.summary       = %q{Create Canvas CC compatible file}
  spec.description   = %q{Create Canvas CC compatible file}
  spec.homepage      = ""
  spec.license       = "AGPLv3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rubyzip", '~> 1.2.1'
  spec.add_runtime_dependency "happymapper"
  spec.add_runtime_dependency "builder"
  spec.add_runtime_dependency "thor"
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "rdiscount"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rspec", "~> 2"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-bundler"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "bundler"
end

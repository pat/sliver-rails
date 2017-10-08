# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "sliver-rails"
  spec.version       = "0.2.1"
  spec.authors       = ["Pat Allan"]
  spec.email         = ["pat@freelancing-gods.com"]
  spec.summary       = "Rails extensions for Sliver"
  spec.homepage      = "https://github.com/pat/sliver-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sliver", "~> 0.1"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop", "~> 0.50.0"
end

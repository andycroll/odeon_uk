# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odeon_uk/version'

Gem::Specification.new do |gem|
  gem.name          = "odeon_uk"
  gem.version       = OdeonUk::VERSION
  gem.authors       = ["Andy Croll"]
  gem.email         = ["andycroll@deepcalm.com"]
  gem.description   = %q{An API to pull movie information from the ODEON.co.uk website}
  gem.summary       = %q{It's a scraper, but a nice one}
  gem.homepage      = "http://github.com/andycroll/odeon_uk"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.version       = OdeonUk::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'webmock'

  gem.add_runtime_dependency 'httparty'
end

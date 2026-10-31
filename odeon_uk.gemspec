lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'odeon_uk/version'

Gem::Specification.new do |spec|
  spec.name          = 'odeon_uk'
  spec.version       = OdeonUk::VERSION
  spec.authors       = ['Andy Croll']
  spec.email         = ['andy@goodscary.com']
  spec.description   = 'Pull movie & cinema information from the ODEON Vista API'
  spec.summary       = "It's a scraper, but a nice one"
  spec.homepage      = 'https://github.com/andycroll/odeon_uk'
  spec.licenses      = %w(AGPL MIT)

  spec.required_ruby_version = '>= 3.4'

  spec.files         = `git ls-files`.split("\n")
  spec.executables   = spec.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'base64'
  spec.add_development_dependency 'bundler', '>= 2.0'
  spec.add_development_dependency 'minitest-mock'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'simplecov', '< 1'
  spec.add_development_dependency 'webmock'

  spec.add_runtime_dependency 'cinebase', '~> 5.6'
end

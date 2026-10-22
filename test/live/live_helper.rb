require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true)
]

require File.expand_path('../../../lib/odeon_uk.rb', __FILE__)
require_relative '../support/api_shapes'

OdeonUk.token = ENV.fetch('ODEON_TOKEN') { OdeonUk.acquire_token! }

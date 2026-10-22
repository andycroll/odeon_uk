require 'simplecov'
SimpleCov.start do
  add_filter '/test/'
end

require 'minitest/autorun'
require 'minitest/mock'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::DefaultReporter.new(color: true, slow_count: 5)
]

require 'webmock/minitest'

require File.expand_path('../../lib/odeon_uk.rb', __FILE__)

require_relative 'support/api_fixtures_helper'
require_relative 'support/api_shapes'
require_relative 'support/fake_api_response'

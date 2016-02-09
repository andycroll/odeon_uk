require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'minitest/autorun'
require 'minitest/reporters'
reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require 'webmock/minitest'

require File.expand_path('../../lib/odeon_uk.rb', __FILE__)

require_relative 'support/api_fixtures_helper'
require_relative 'support/fake_api_response'

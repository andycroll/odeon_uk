require_relative '../../../test_helper'

class OdeonUk::Internal::ApiResponseTest < Minitest::Test
  include ApiFixturesHelper

  BASE_URL = 'https://vwc.odeon.co.uk/WSVistaWebClient/ocapi/v1'.freeze
  HEADERS = {
    'Authorization' => 'Bearer guest-jwt', 'Connect-Region-Code' => 'UK'
  }.freeze

  def setup
    OdeonUk.token = 'guest-jwt'
  end

  def teardown
    OdeonUk.token = nil
    super
  end

  def test_sites
    stub_request(:get, "#{BASE_URL}/sites")
      .with(headers: HEADERS)
      .to_return(status: 200, body: sites_json)

    sites = api.sites

    assert_kind_of Array, sites
    assert_includes sites.first.keys, 'id'
  end

  def test_showtimes
    stub_request(:get, "#{BASE_URL}/showtimes/by-business-date/2026-10-24")
      .with(query: { 'siteIds' => '824' }, headers: HEADERS)
      .to_return(status: 200, body: showtimes_json('824'))

    showtimes = api.showtimes('824', Date.new(2026, 10, 24))

    assert_equal %w(businessDate relatedData showtimes), showtimes.keys.sort
  end

  def test_missing_token_raises_before_request
    OdeonUk.token = nil

    assert_raises(OdeonUk::AuthenticationError) { api.sites }
  end

  def test_rejected_token_raises
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 401)

    assert_raises(OdeonUk::AuthenticationError) { api.sites }
  end

  def test_rejected_token_is_cleared
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 401)

    assert_raises(OdeonUk::AuthenticationError) { api.sites }

    assert_nil OdeonUk.token
  end

  def test_server_error_omits_body
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 500, body: 'secret')

    error = assert_raises(RuntimeError) { api.sites }

    assert_equal 'Vista HTTP error 500', error.message
  end

  def test_reuses_one_client_while_the_token_holds
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 200, body: sites_json)
    shared = api

    assert_equal 1, count_clients { 3.times { shared.sites } }
  end

  def test_builds_a_new_client_for_a_new_token
    stub_request(:get, "#{BASE_URL}/sites").to_return(status: 200, body: sites_json)
    shared = api

    clients = count_clients do
      shared.sites
      OdeonUk.token = 'renewed-jwt'
      shared.sites
    end

    assert_equal 2, clients
  end

  private

  def count_clients
    clients = 0
    original = Cinebase::Vista::Client.method(:new)
    counting = ->(**options) { clients += 1; original.call(**options) }
    Cinebase::Vista::Client.stub(:new, counting) { yield }
    clients
  end

  def api
    OdeonUk::Internal::ApiResponse.new
  end
end

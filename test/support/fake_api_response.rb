require_relative 'api_fixtures_helper'

class FakeApiResponse
  include ApiFixturesHelper

  attr_reader :requested_dates

  def initialize
    @requested_dates = []
  end

  def sites
    JSON.parse(sites_json).fetch('sites')
  end

  def showtimes(cinema_id, date)
    @requested_dates << date
    JSON.parse(showtimes_json(cinema_id))
  end
end

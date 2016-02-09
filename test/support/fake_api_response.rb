require_relative 'api_fixtures_helper'

class FakeApiResponse
  include ApiFixturesHelper

  def app_init
    parse(app_init_plist)
  end

  def all_cinemas
    parse(all_cinemas_plist)
  end

  def film_times(cinema_id, film_id)
    parse(film_times_plist(cinema_id, film_id))
  end
end

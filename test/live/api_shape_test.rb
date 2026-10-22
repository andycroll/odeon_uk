require_relative 'live_helper'

class LiveApiShapeTest < Minitest::Test
  include ApiShapes

  def test_sites_are_readable
    assert_sites_shape('sites' => api.sites)
  end

  def test_showtimes_are_readable
    assert_showtimes_shape(api.showtimes('824', Date.today + 1))
  end

  private

  def api
    OdeonUk::Internal::ApiResponse.new
  end
end

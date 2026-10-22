require_relative '../../../test_helper'

class FixtureShapeTest < Minitest::Test
  include ApiFixturesHelper
  include ApiShapes

  def test_sites_fixture_matches_shape
    assert_sites_shape(JSON.parse(sites_json))
  end

  def test_showtimes_fixture_matches_shape
    assert_showtimes_shape(JSON.parse(showtimes_json('824')))
  end
end

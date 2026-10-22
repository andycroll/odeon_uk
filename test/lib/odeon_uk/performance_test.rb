require_relative '../../test_helper'

class OdeonUk::PerformanceTest < Minitest::Test
  DATE = Date.new(2026, 10, 24)

  def setup
    @api_response = FakeApiResponse.new
  end

  def test_at_returns_performances
    performances = performances_at(824)

    assert(performances.all? { |p| p.instance_of?(OdeonUk::Performance) })
    assert_equal 6, performances.count
  end

  def test_at_accepts_string_id
    assert_equal 6, performances_at('824').count
  end

  def test_at_sets_cinema_details
    performances = performances_at(824)

    assert_equal ['824'], performances.map(&:cinema_id).uniq
    assert_equal ['Brighton'], performances.map(&:cinema_name).uniq
  end

  def test_at_parses_first_performance
    performance = performances_at(824).first

    assert_equal 'The Example Film', performance.film_name
    assert_equal Time.utc(2026, 10, 24, 8, 0), performance.starting_at
    assert_equal '2d', performance.dimension
    assert_equal %w(audio_described), performance.variant
    assert_equal 'https://www.odeon.co.uk/ticketing/seat-picker/?showtimeId=824-1001',
                 performance.booking_url
  end

  def test_at_parses_3d_imax
    performance = performances_at(824)[1]

    assert_equal '3d', performance.dimension
    assert_equal %w(imax), performance.variant
  end

  def test_at_returns_language_and_subtitles
    performances = performances_at(824)
    tamil = performances[3]
    korean = performances[2]

    assert_equal 'Imaginary Picture', tamil.film_name
    assert_equal 2025, tamil.film_year
    assert_equal 'Tamil', tamil.language
    assert tamil.subtitled?
    assert_equal 'Korean', korean.language
    assert_equal %w(arts subtitled), korean.variant
  end

  def test_at_treats_open_captions_as_subtitled
    kids = performances_at(824)[4]

    assert_nil kids.language
    assert_equal %w(kids subtitled), kids.variant
    assert kids.subtitled?
  end

  def test_at_keeps_after_midnight_on_next_utc_day
    assert_equal Time.utc(2026, 10, 24, 23, 15), performances_at(824).last.starting_at
  end

  def test_at_requests_each_date_in_range
    to = DATE + 2

    with_fake_api { OdeonUk::Performance.at(824, from: DATE, to: to) }

    assert_equal (DATE..to).to_a, @api_response.requested_dates
  end

  def test_at_rejects_range_ending_before_start
    assert_raises(ArgumentError) do
      OdeonUk::Performance.at(824, from: DATE, to: DATE - 1)
    end
  end

  def test_new_sets_names
    performance = OdeonUk::Performance.new(options)

    assert_equal 'The Big Short', performance.film_name
    assert_equal 'Brighton', performance.cinema_name
  end

  def test_new_sets_defaults
    performance = OdeonUk::Performance.new(options)

    assert_nil performance.booking_url
    assert_nil performance.festival
    assert_equal '2d', performance.dimension
    assert_nil performance.language
    refute performance.subtitled?
    assert_equal [], performance.variant
  end

  def test_language
    assert_equal 'Tamil', OdeonUk::Performance.new(options(language: 'Tamil')).language
  end

  def test_festival
    festival = Cinebase::Festival.new(name: 'Cine-Excess', year: 2026)
    performance = OdeonUk::Performance.new(options(festival: festival))

    assert_equal festival, performance.festival
  end

  def test_film_year
    assert_equal 1996, OdeonUk::Performance.new(options(film_year: 1996)).film_year
  end

  def test_subtitled
    assert OdeonUk::Performance.new(options(variant: %w(subtitled))).subtitled?
  end

  def test_starting_at_converts_local_time_to_utc
    starting_at = OdeonUk::Performance.new(
      options(starting_at: Time.new(2013, 9, 12, 11, 0))
    ).starting_at

    assert_equal Time.utc(2013, 9, 12, 10, 0), starting_at
    assert starting_at.utc?
  end

  def test_variant_is_sorted_and_lower_case
    performance = OdeonUk::Performance.new(options(variant: %w(Subtitled Senior)))

    assert_equal %w(senior subtitled), performance.variant
  end

  private

  def options(overrides = {})
    {
      film_name:   'The Big Short',
      cinema_id:   '824',
      cinema_name: 'Brighton',
      starting_at: Time.utc(2013, 9, 12, 11, 0)
    }.merge(overrides)
  end

  def performances_at(cinema_id)
    with_fake_api { OdeonUk::Performance.at(cinema_id, from: DATE, to: DATE) }
  end

  def with_fake_api(&block)
    OdeonUk::Internal::ApiResponse.stub(:new, @api_response, &block)
  end
end

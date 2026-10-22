require_relative '../../../../../test_helper'

class OdeonUk::Internal::Parser::Api::ShowtimeTest < Minitest::Test
  FILMS = {
    'HO1' => { 'title' => { 'text' => 'Jailer 2 (Tamil)' } },
    'HO2' => { 'title' => { 'text' => 'Cine-Excess 2026: Scum Of The Earth' } }
  }.freeze

  ATTRIBUTES = {
    '1' => { 'shortName' => { 'text' => 'TamilA' }, 'name' => { 'text' => 'Tamil (Audio)' } },
    '2' => { 'shortName' => { 'text' => 'EnglishSub' }, 'name' => { 'text' => 'English (Sub)' } },
    '3' => { 'shortName' => { 'text' => 'IMAX' }, 'name' => { 'text' => 'IMAX' } },
    '4' => { 'shortName' => { 'text' => 'OpenCapt' }, 'name' => { 'text' => 'Open Captioned' } },
    '5' => { 'shortName' => { 'text' => 'Wheelchair' }, 'name' => { 'text' => 'Wheelchair Accessible' } }
  }.freeze

  def test_to_hash
    expected = {
      booking_url: 'https://www.odeon.co.uk/ticketing/seat-picker/?showtimeId=824-1',
      dimension: '2d',
      festival: nil,
      film_name: 'Jailer 2',
      language: nil,
      starting_at: Time.utc(2026, 10, 24, 17, 30),
      variant: []
    }

    assert_equal expected, parse
  end

  def test_3d_glasses
    assert_equal '3d', parse(requires3d: true)[:dimension]
  end

  def test_audio_language
    assert_equal 'Tamil', parse(attribute_ids: %w(1 2 3 5))[:language]
  end

  def test_maps_known_attributes_to_variants
    assert_equal %w(subtitled imax), parse(attribute_ids: %w(1 2 3 5))[:variant]
  end

  def test_festival_moves_from_title_to_attribute
    showtime = parse(film_id: 'HO2')

    assert_equal Cinebase::Festival.new(name: 'Cine-Excess', year: 2026), showtime[:festival]
    assert_equal 'Scum Of The Earth', showtime[:film_name]
  end

  def test_open_captions_and_subtitles_are_one_variant
    assert_equal %w(subtitled), parse(attribute_ids: %w(2 4))[:variant]
  end

  private

  def parse(attribute_ids: [], requires3d: false, film_id: 'HO1')
    data = {
      'id' => '824-1',
      'filmId' => film_id,
      'schedule' => { 'startsAt' => '2026-10-24T18:30:00+01:00' },
      'attributeIds' => attribute_ids,
      'requires3dGlasses' => requires3d
    }
    OdeonUk::Internal::Parser::Api::Showtime.new(
      data, films: FILMS, attributes: ATTRIBUTES
    ).to_hash
  end
end

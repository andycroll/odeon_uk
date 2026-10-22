require_relative '../../../test_helper'

class OdeonUk::Internal::TitleSanitizerTest < Minitest::Test
  def test_removes_2d
    assert_sanitized 'Iron Man 3', 'Iron Man 3 2D'
  end

  def test_removes_3d
    assert_sanitized 'Iron Man 3', 'Iron Man 3 3D'
  end

  def test_removes_autism_prefix
    assert_sanitized 'Planes', 'Autism Friendly Screening - Planes'
  end

  def test_bolshoi
    assert_sanitized 'Bolshoi: Spartacus', 'Bolshoi - Spartacus (Live)'
  end

  def test_removes_cinemagic_prefix
    assert_sanitized 'Echo Planet', 'Cinemagic 2013 - Echo Planet'
  end

  def test_globe_on_screen
    assert_sanitized 'Globe: Twelfth Night', 'Globe On Screen: Twelfth Night'
  end

  def test_met_opera
    assert_sanitized 'Met Opera: Eugene Onegin 2013', 'Met Opera - Eugene Onegin 2013'
  end

  def test_met_opera_season
    assert_sanitized 'Met Opera: La Fanciulla del West',
                     'Met Opera 2026-27: La Fanciulla del West'
  end

  def test_nt_live
    assert_sanitized 'National Theatre: War Horse', 'NT Live - War Horse'
  end

  def test_national_theatre_encore
    assert_sanitized 'National Theatre: Frankenstein',
                     'National Theatre Live - Frankenstein (Encore Screening)'
  end

  def test_roh
    assert_sanitized 'Royal Opera House: Carmen', 'ROH - Carmen'
  end

  def test_rbo_season
    assert_sanitized 'Royal Ballet and Opera: Swan Lake',
                     'RBO Cinema Season 2026-27: Swan Lake'
  end

  def test_short_rbo_season
    assert_sanitized "Royal Ballet and Opera: Alice's Adventures in Wonderland",
                     "RBO 2026-27: Alice's Adventures in Wonderland"
  end

  def test_rsc
    assert_sanitized 'Royal Shakespeare Company: Richard II', 'Richard II - RSC Live 2013'
  end

  def test_removes_ukjff_prefix
    assert_sanitized 'From Cable Street To Brick Lane',
                     'UKJFF - From Cable Street To Brick Lane'
  end

  def test_removes_singalong
    assert_sanitized 'Frozen', 'Frozen Sing-a-long'
  end

  def test_html_ampersands
    assert_sanitized 'Fast & Furious 7', 'Fast &amp; Furious 7'
  end

  def test_removes_language_suffix
    assert_sanitized 'Jailer 2', 'Jailer 2 (Telugu)'
  end

  def test_removes_encore_suffix
    assert_sanitized 'Avengers Endgame', 'Avengers Endgame: Encore'
  end

  def test_keeps_sing_along_within_title
    assert_sanitized 'Bebefinn Sing-Along Movie', 'Bebefinn Sing-Along Movie'
  end

  def test_removes_dubbed
    assert_sanitized 'Arrietty', 'Arrietty (Dubbed)'
  end

  def test_removes_subbed
    assert_sanitized 'Arrietty', 'Arrietty (Subbed)'
  end

  def test_removes_english_dub
    assert_sanitized 'Kung Fu Soccer', 'Kung Fu Soccer (English Dub)'
  end

  def test_removes_subtitle_description
    assert_sanitized 'Kung Fu Soccer', 'Kung Fu Soccer (Mandarin with EN/CH subtitles)'
  end

  def test_removes_q_and_a
    assert_sanitized 'NAZA', 'NAZA + Q&A'
  end

  def test_removes_in_person_q_and_a
    assert_sanitized "Charlie Shaw's Revenge", "Charlie Shaw's Revenge + In-Person Q&A"
  end

  def test_removes_festival_prefix
    assert_sanitized 'Scum Of The Earth', 'Cine-Excess 2026: Scum Of The Earth'
  end

  def test_removes_anniversary
    assert_sanitized 'SCREAM', 'SCREAM (30th Anniversary)'
  end

  def test_world_tour_is_not_capitalised
    assert_sanitized "ENHYPEN World Tour 'BLOOD SAGA'", "ENHYPEN WORLD TOUR 'BLOOD SAGA'"
  end

  def test_keeps_titles_with_their_own_subtitles
    [
      'Harry Potter and the Deathly Hallows: Part 1',
      'Spider-Man: Brand New Day',
      'Hadestown: The Musical',
      'Rammstein - Live in Mexico City',
      'Ozzy & Black Sabbath: Back to the Beginning',
      "BTS 'ARIRANG' IN BUENOS AIRES: LIVE VIEWING"
    ].each { |title| assert_sanitized title, title }
  end

  private

  def assert_sanitized(expected, title)
    assert_equal expected, OdeonUk::Internal::TitleSanitizer.new(title).sanitized
  end
end

require_relative '../../test_helper'

class OdeonUk::CinemaTest < Minitest::Test
  def setup
    @api_response = FakeApiResponse.new
  end

  def test_new_returns_cinema_with_string_id
    cinema = OdeonUk::Cinema.new(824)

    assert_instance_of OdeonUk::Cinema, cinema
    assert_equal '824', cinema.id
  end

  def test_new_zero_pads_id
    assert_equal '017', OdeonUk::Cinema.new(17).id
  end

  def test_all_returns_cinemas
    with_fake_api do
      cinemas = OdeonUk::Cinema.all

      assert(cinemas.all? { |cinema| cinema.instance_of?(OdeonUk::Cinema) })
      assert_equal %w(017 153 824 955), cinemas.map(&:id)
    end
  end

  def test_adr_has_no_postcode
    expected = {
      street_address:   '3 Example Parade',
      extended_address: 'Seafront',
      locality:         'Brighton',
      region:           nil,
      postal_code:      nil,
      country_name:     'United Kingdom'
    }

    with_fake_api do
      assert_equal expected, OdeonUk::Cinema.new(824).adr
    end
  end

  def test_address_for_london
    expected = {
      street_address:   '2 Example Square',
      extended_address: '',
      locality:         'London',
      region:           nil,
      postal_code:      nil,
      country_name:     'United Kingdom'
    }

    with_fake_api do
      assert_equal expected, OdeonUk::Cinema.new(153).address
    end
  end

  def test_brand
    assert_equal 'Odeon', OdeonUk::Cinema.new(824).brand
  end

  def test_full_name
    with_fake_api do
      assert_equal 'Odeon Brighton', OdeonUk::Cinema.new(824).full_name
      assert_equal 'Odeon Leicester Square', OdeonUk::Cinema.new(153).full_name
    end
  end

  def test_latitude_and_longitude
    with_fake_api do
      cinema = OdeonUk::Cinema.new(824)

      assert_in_delta 50.8215, cinema.latitude, 0.0001
      assert_in_delta(-0.146, cinema.longitude, 0.0001)
    end
  end

  def test_latitude_and_longitude_are_nil_without_a_location
    with_fake_api do
      [153, 955].each do |id|
        assert_nil OdeonUk::Cinema.new(id).latitude
        assert_nil OdeonUk::Cinema.new(id).longitude
      end
    end
  end

  def test_latitude_and_longitude_are_nil_at_zero_zero
    with_fake_api do
      assert_nil OdeonUk::Cinema.new(17).latitude
      assert_nil OdeonUk::Cinema.new(17).longitude
    end
  end

  def test_name_removes_london_prefix
    with_fake_api do
      assert_equal 'Leicester Square', OdeonUk::Cinema.new(153).name
    end
  end

  def test_postal_code_is_empty
    with_fake_api do
      assert_equal '', OdeonUk::Cinema.new(824).postal_code
    end
  end

  def test_slug
    with_fake_api do
      assert_equal 'odeon-brighton', OdeonUk::Cinema.new(824).slug
    end
  end

  def test_url
    with_fake_api do
      assert_equal 'https://www.odeon.co.uk/cinemas/brighton/',
                   OdeonUk::Cinema.new(824).url
    end
  end

  def test_url_keeps_london_prefix
    with_fake_api do
      assert_equal 'https://www.odeon.co.uk/cinemas/london-leicester-square/',
                   OdeonUk::Cinema.new(153).url
    end
  end

  def test_url_uses_slug_that_differs_from_name
    with_fake_api do
      assert_equal 'https://www.odeon.co.uk/cinemas/manchester-trafford-centre/',
                   OdeonUk::Cinema.new(955).url
    end
  end

  private

  def with_fake_api(&block)
    OdeonUk::Internal::ApiResponse.stub(:new, @api_response, &block)
  end
end

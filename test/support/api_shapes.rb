require 'time'

# The parts of Vista responses the gem reads. Checked against the hand-written
# fixtures and, in the live suite, against real responses held only in memory.
module ApiShapes
  private

  def assert_sites_shape(data)
    sites = data.fetch('sites')
    refute_empty sites
    sites.each do |site|
      assert_match(/\A\d{3}\z/, site.fetch('id'))
      assert_kind_of String, site.dig('name', 'text')
      address = site.fetch('contactDetails').fetch('address')
      %w(line1 line2 city).each do |key|
        assert_kind_of String, address.fetch(key), "site #{site['id']} #{key}"
      end
    end
  end

  def assert_showtimes_shape(data)
    related = data.fetch('relatedData')
    films = related.fetch('films').to_h { |film| [film.fetch('id'), film] }
    attributes = related.fetch('attributes').to_h do |attribute|
      [attribute.fetch('id'), attribute]
    end

    films.each_value { |film| assert_kind_of String, film.dig('title', 'text') }
    attributes.each_value do |attribute|
      assert_kind_of String, attribute.dig('shortName', 'text')
      assert_kind_of String, attribute.dig('name', 'text')
    end

    showtimes = data.fetch('showtimes')
    refute_empty showtimes
    showtimes.each do |showtime|
      assert_kind_of String, showtime.fetch('id')
      assert_includes films.keys, showtime.fetch('filmId')
      assert_kind_of Time, Time.iso8601(showtime.fetch('schedule').fetch('startsAt'))
      assert_includes [true, false], showtime.fetch('requires3dGlasses')
      showtime.fetch('attributeIds').each do |id|
        assert_includes attributes.keys, id
      end
    end
  end
end

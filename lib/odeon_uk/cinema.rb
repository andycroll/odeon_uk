module OdeonUk

  # Public: The object representing a cinema on the Odeon UK website
  class Cinema

    # Public: Returns the String brand of the cinema #=> 'Odeon'
    attr_reader :brand
    # Public: Returns the Integer id of the cinema on teh odeon website
    attr_reader :id
    # Public: Returns the String name of the cinema
    attr_reader :name
    # Public: Returns the String slug of the cinema
    attr_reader :slug
    # Public: Returns the String url of the cinema's page on odeon.co.uk
    attr_reader :url

    # Public: Initialize a cinema
    #
    # id   - Integer/String of the cinema on the odeon website
    # name - String of cinema name
    # url  - String of cinema url on the odeon website
    def initialize(id, name, url)
      @brand = 'Odeon'
      @id    = id.to_i
      @name  = name
      @slug  = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
      @url   = (url[0] == '/') ? "http://www.odeon.co.uk#{url}" : url
    end

    # Public: Return basic cinema information for all Odeon cinemas
    #
    # Examples
    #
    #   OdeonUk::Cinema.all
    #   # => [<OdeonUk::Cinema brand="Odeon" name="Odeon Tunbridge Wells" slug="odeon-tunbridge-wells" id=23 url="...">, #=> <OdeonUk::Cinema brand="Odeon" name="Odeon Brighton" slug="odeon-brighton" chain_id="71" url="...">, ...]
    #
    # Returns an array of hashes of cinema information.
    def self.all
      cinema_links.map do |link|
        new_from_link link
      end
    end

    # Public: Return single cinema information for an Odeon cinema
    #
    # id_string - a string/int representing the cinema id
    #             of the format '32'/32 as used on the odeon.co.uk website
    #
    # Examples
    #
    #   OdeonUk::Cinema.find('71')
    #   # => <OdeonUk::Cinema brand="Odeon" name="Brighton" slug="brighton" id=71 url="...">
    #
    # Returns an Odeon::Cinema or nil if none was found
    def self.find(id)
      id = id.to_i
      return nil unless id > 0

      all.select { |cinema| cinema.id == id }[0]
    end

    # Public: Returns adress hash of an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.adr
    #   # => { street_address: 'Kingswest',
    #          locality: 'Brighton',
    #          postal_code: 'BN1 2RE',
    #          country_name: 'United Kingdom' }
    #
    # Returns an array of strings or nil
    def adr
      {
        street_address: street_address,
        locality: locality,
        postal_code: postal_code,
        country: 'United Kingdom'
      }
    end

    # Public: Returns films for an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.films
    #   # => [<OdeonUk::Film name="Iron Man 3">, <OdeonUk::Film name="Star Trek Into Darkness">]
    #
    # Returns an array of Odeon::Film objects
    def films
      film_nodes.map do |node|
        parser = OdeonUk::Internal::FilmWithScreeningsParser.new node.to_s
        OdeonUk::Film.new parser.film_name
      end.uniq
    end

    # Public: Returns the locality (town) of an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.locality
    #   # => 'Brighton'
    #
    # Returns a String
    def locality
      address_node.text.match(/\w+(\s\w+){0,}\s+(\w+(\s\w+){0,})/)[2]
    end


    # Public: Returns the postal code of an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.postal_code
    #   # => 'BN1 2RE'
    #
    # Returns a String
    def postal_code
      address_node.text.match(/[A-Z]{1,2}\d{1,2}[A-Z]?\s\d{1,2}[A-Z]{1,2}/)[0]
    end

    # Public: Returns screenings for an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.screenings
    #   # => [<OdeonUk::Screening film_name="Iron Man 3" cinema_name="Brighton" when="..." varient="...">, <OdeonUk::Screening ...>]
    #
    # Returns an array of Odeon::Screening objects
    def screenings
      film_nodes.map do |node|
        parser = OdeonUk::Internal::FilmWithScreeningsParser.new node.to_s
        parser.showings.map do |screening_type, times|
          times.map do |time|
            OdeonUk::Screening.new parser.film_name, self.name, time.strftime('%d/%m/%Y'), time.strftime('%H:%M:%S'), nil
          end
        end
      end.flatten
    end

    # Public: Returns screenings for particular film at an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.screenings_of 'Iron Man 3'
    #   # => [<OdeonUk::Screening film_name="Iron Man 3" cinema_name="Brighton" when="..." varient="...">, <OdeonUk::Screening ...>]
    #   cinema.screenings_of <OdeonUk::Film name="Iron Man 3">
    #   # => [<OdeonUk::Screening film_name="Iron Man 3" cinema_name="Brighton" when="..." varient="...">, <OdeonUk::Screening ...>]
    #
    # Returns an array of Odeon::Screening objects
    def screenings_of film
      film_name = (film.is_a?(OdeonUk::Film) ? film.name : film)
      screenings.select { |s| s.film_name == film_name }
    end

    # Public: Returns the street adress of an Odeon cinema
    #
    # Examples
    #
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.street_address
    #   # => 'Kingswest'
    #
    # Returns a String
    def street_address
      address_node.text.match(/\A\s+(\w+(\s\w+){0,})/)[1]
    end

    private

    def self.cinema_links
      links = parsed_sitemap.css('.sitemap > .span12:nth-child(4) a[href*=cinemas]')
      links.select { |link| link.get_attribute('href').match(/\/\d+\/$/) }
    end

    def self.new_from_link(link)
      url  = link.get_attribute('href')
      id   = url.match(/\/(\d+)\/$/)[1]
      name = link.children.first.to_s
      new id, name, url
    end

    def self.parsed_sitemap
      Nokogiri::HTML(sitemap_response)
    end

    def self.sitemap_response
      @sitemap_response ||= HTTParty.get('http://www.odeon.co.uk/sitemap/')
    end

    def address_node
      parsed_cinema.css('.gethere .span4 .description')[0]
    end

    def cinema_response
      @cinema_response ||= HTTParty.get(@url)
    end

    def parsed_cinema
      Nokogiri::HTML(cinema_response)
    end

    def film_nodes
      parsed_showtimes.css('.film-detail')
    end

    def parsed_showtimes
      Nokogiri::HTML(showtimes_response)
    end

    def showtimes_response
      @showtimes_response ||= HTTParty.get("http://www.odeon.co.uk/showtimes/week/#{@id}?siteId=#{@id}")
    end
  end
end

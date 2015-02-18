module OdeonUk
  # The object representing a cinema on the Odeon UK website
  class Cinema
    # @return [String] the brand of the cinema
    attr_reader :brand
    # @return [Integer] the numeric id of the cinema on the Odeon website
    attr_reader :id
    # @return [String] the name of the cinema
    attr_reader :name
    # @return [String] the slug of the cinema
    attr_reader :slug
    # @return [String] the url of the cinema on the Odeon website
    attr_reader :url

    # @param [Integer, String] id cinema id
    # @param [String] name cinema name
    # @param [String] url url on Odeon website
    # @return [OdeonUk::Cinema]
    def initialize(id, name, url)
      @brand = 'Odeon'
      @id    = id.to_i
      @name  = name.gsub('London - ', '').gsub(' - ', ': ')
      @slug  = @name.downcase.gsub(/[^0-9a-z ]/, '').gsub(/\s+/, '-')
      @url   = (url[0] == '/') ? "http://www.odeon.co.uk#{url}" : url
    end

    # Return basic cinema information for all cinemas
    # @return [Array<OdeonUk::Cinema>]
    def self.all
      cinema_links.map do |link|
        new_from_link link
      end
    end

    # Find a single cinema
    # @param [Integer, String] id the cinema id of the format 71/'71' as used on
    # the odeon.co.uk website
    # @return [OdeonUk::Cinema, nil]
    # @example
    #   OdeonUk::Cinema.find('71')
    #   #=> <OdeonUk::Cinema brand="Odeon" name="Brighton" slug="brighton" ...>
    def self.find(id)
      id = id.to_i
      return nil unless id > 0

      all.select { |cinema| cinema.id == id }[0]
    end

    # Address of the cinema
    # @return [Hash] of different address parts
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.adr
    #   #=> { street_address: 'Kingswest',
    #         locality: 'Brighton',
    #         postal_code: 'BN1 2RE',
    #         country_name: 'United Kingdom' }
    def adr
      {
        street_address: street_address,
        locality: locality,
        postal_code: postal_code,
        country: 'United Kingdom'
      }
    end
    alias_method :address, :adr

    # Films with showings scheduled at this cinema
    # @return [Array<OdeonUk::Film>]
    def films
      Film.at(id)
    end

    # The name of the cinema including the brand
    # @return [String]
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.full_name
    #   #=> 'Odeon Brighton'
    def full_name
      "#{brand} #{name}"
    end

    # The locality (town) of the cinema
    # @return [String]
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.locality
    #   #=> 'Brighton'
    def locality
      return unless address_node
      address_node.text.match(/\w+(\s\w+){0,}\s+(\w+(\s\w+){0,})/)[2]
    end

    # Post code of the cinema
    # @return [String]
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.postal_code
    #   #=> 'BN1 2RE'
    def postal_code
      return unless address_node
      address_node.text.match(/[A-Z]{1,2}\d{1,2}[A-Z]?\s\d{1,2}[A-Z]{1,2}/)[0]
    end

    # All planned screenings
    # @return [Array<OdeonUk::Screening>]
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.screenings
    #   #=> [<OdeonUk::Screening film_name="Iron Man 3" cinema_name="Brighton" when="..." variant="...">, <OdeonUk::Screening ...>]
    def screenings
      Screening.at(id)
    end

    # Screenings for particular film
    # @param [OdeonUk::Film, String] film a film object or title of the film
    # @return [Array<Odeon::Screening>]
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.screenings_of('Iron Man 3')
    #   #=> [<OdeonUk::Screening film_name="Iron Man 3" cinema_name="Brighton" when="..." variant="...">, <OdeonUk::Screening ...>]
    #   iron_man_3 = OdeonUk::Film.new "Iron Man 3"
    #   cinema.screenings_of(iron_man_3)
    #   #=> [<OdeonUk::Screening film_name="Iron Man 3" cinema_name="Brighton" when="..." variant="...">, <OdeonUk::Screening ...>]
    def screenings_of film
      film_name = (film.is_a?(OdeonUk::Film) ? film.name : film)
      screenings.select { |s| s.film_name == film_name }
    end

    # The street adress of the cinema
    # @return a String
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.street_address
    #   #=> 'Kingswest'
    def street_address
      return unless address_node
      address_node.text.match(/\A\s+(\w+(\s\w+){0,})/)[1]
    end

    private

    def self.cinema_links
      links = parsed_sitemap.css('.sitemap a[href*=cinemas]')
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
      @sitemap_response ||= OdeonUk::Internal::Website.new.sitemap
    end

    def address_node
      parsed_cinema.css('.gethere .span4 .description')[0]
    end

    def cinema_response
      @cinema_response ||= OdeonUk::Internal::Website.new.cinema(@id)
    end

    def parsed_cinema
      Nokogiri::HTML(cinema_response)
    end
  end
end

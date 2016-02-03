module OdeonUk
  # The object representing a cinema on the Odeon UK website
  class Cinema
    extend Forwardable

    # @return [Integer] the numeric id of the cinema on the Odeon website
    attr_reader :id

    # @!method locality
    #   The locality (town) of the cinema
    #   @return [String]
    #   @example
    #     cinema = OdeonUk::Cinema.find('71')
    #     cinema.locality
    #     #=> 'Brighton'
    # @!method postal_code
    #   Post code of the cinema
    #   @return [String]
    #   @example
    #     cinema = OdeonUk::Cinema.find('71')
    #     cinema.postal_code
    #     #=> 'BN1 2RE'
    # @!method street_address
    #   The street adress of the cinema
    #   @return [String]
    #   @example
    #     cinema = OdeonUk::Cinema.find('71')
    #     cinema.street_address
    #     #=> 'Kingswest'
    # @!method url
    #   Website URI for the cinema
    #   @return [String] the url of the cinema on the Odeon website
    def_delegators :cinema_parser, :locality, :postal_code, :street_address,
                                   :url

    # @param [Integer, String] id the cinema id of the format 71/'71' as used on
    # the odeon.co.uk website
    # @return [OdeonUk::Cinema]
    def initialize(id)
      @id = id
    end

    # Return basic cinema information for all cinemas
    # @return [Array<OdeonUk::Cinema>]
    def self.all
      cinema_parser_class.ids.map { |cinema_id| new(cinema_id) }
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
        locality:       locality,
        postal_code:    postal_code,
        country_name:   'United Kingdom'
      }
    end
    alias_method :address, :adr

    # @return [String] 'Odeon'
    def brand
      'Odeon'
    end

    # The name of the cinema including the brand
    # @return [String]
    # @example
    #   cinema = OdeonUk::Cinema.find('71')
    #   cinema.full_name
    #   #=> 'Odeon Brighton'
    def full_name
      @full_name ||= "#{brand} #{name}"
    end

    # Cinema name, slightly sanitized
    # @return [String] the name of the cinema
    def name
      @name ||= cinema_parser.name.gsub('London - ', '').gsub(' - ', ': ')
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

    # slug from the hotel name
    # @return [String] the slug of the cinema
    def slug
      @slug ||= full_name.downcase.gsub(/[^0-9a-z ]/, '').gsub(/\s+/, '-')
    end

    private

    def cinema_parser
      @cinema_parser ||= Api::Cinema.new(id)
    end
  end
end

module OdeonUk
  # The object representing a cinema on the Odeon UK website
  class Cinema < Cinebase::Cinema
    # @!attribute [r] id
    #   @return [Integer] the numeric id of the cinema on the Cineworld website

    # Constructor
    # @param [Integer, String] id the cinema id of the format 71/'71' as used on
    # @return [OdeonUk::Cinema]
    def initialize(id)
      @id = id.to_s
    end

    # Return basic cinema information for all cinemas
    # @return [Array<OdeonUk::Cinema>]
    # @example
    #   OdeonUk::Cinema.all
    #   #=> [<OdeonUk::Cinema>, <OdeonUk::Cinema>, ...]
    def self.all
      cinemas_hash.keys.map { |cinema_id| new(cinema_id) }
    end

    # @!method address
    #   Address of the cinema
    #   @return [Hash] of different address parts
    #   @see #adr

    # Address of the cinema
    # @return [Hash] contains :street_address, :extended_address,
    # :locality, :postal_code, :country
    # @example
    #   cinema = OdeonUk::Cinema.new(3)
    #   cinema.adr
    #   #=> {
    #         street_address: '44-47 Gardner Street',
    #         extended_address: 'North Laine',
    #         locality: 'Brighton',
    #         postal_code: 'BN1 1UN',
    #         country_name: 'United Kingdom'
    #       }
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    def adr
      {
        street_address:   cinema_hash['siteAddress1'],
        extended_address: nil,
        locality:         cinema_hash['siteAddress2'],
        region:           nil,
        postal_code:      cinema_hash['sitePostcode'],
        country_name:     'United Kingdom'.freeze
      }
    end

    # Brand of the cinema
    # @return [String] which will always be 'Odeon'
    # @example
    #   cinema = OdeonUk::Cinema.new(3)
    #   cinema.brand
    #   #=> 'Cineworld'
    def brand
      'Odeon'.freeze
    end

    # @!method country_name
    #   Country of the cinema
    #   @return [String] which will always be 'United Kingdom'
    #   @example
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.country_name
    #     #=> 'United Kingdom'

    # @!method extended_address
    #   The second address line of the cinema
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(10)
    #     cinema.extended_address
    #     #=> 'Chelsea'
    #
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.extended_address
    #     #=> ''

    # @!method full_name
    #   The name of the cinema including the brand
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(88)
    #     cinema.full_name
    #     #=> 'Cineworld Glasgow: IMAX at GSC'

    # @!method locality
    #   The locality (town) of the cinema
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.locality
    #     #=> 'Brighton'

    # The name of the cinema
    # @return [String]
    # @example
    #   cinema = CineworldUk::Cinema.new(3)
    #   cinema.name
    #   #=> 'Brighton'
    def name
      @name ||= cinema_hash['siteName'].gsub(/\ALondon /, '').gsub(' - ', ': ')
    end

    # @!method postal_code
    #   Post code of the cinema
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.postal_code
    #     #=> 'BN2 5UF'

    # @!method region
    #   The region (county) of the cinema if provided
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.region
    #     #=> 'East Sussex'

    # @!method slug
    #   The URL-able slug of the cinema
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.slug
    #     #=> 'odeon-brighton'

    # @!method street_address
    #   The street address of the cinema
    #   @return [String]
    #   @example
    #     cinema = CineworldUk::Cinema.new(3)
    #     cinema.street_address
    #     #=> 'Brighton Marina'
    #   @note Uses the standard method naming as at http://microformats.org/wiki/adr

    # The url of the cinema on the Cineworld website
    # @return [String]
    def url
      "http://www.odeon.co.uk/cinemas/#{urlized_name}/#{id}/"
    end

    private

    def self.cinemas_hash
      @cinemas_hash ||=
        OdeonUk::Internal::ApiResponse.new.all_cinemas.fetch('sites', {})
    end

    def cinema_hash
      @cinema_hash ||= self.class.cinemas_hash.fetch(id, {})
    end

    def urlized_name
      name.downcase.gsub(/[^a-z0-9]/, '_')
    end
  end
end

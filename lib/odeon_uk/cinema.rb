module OdeonUk
  # The object representing a cinema on the Odeon UK website
  class Cinema < Cinebase::Cinema
    # @!attribute [r] id
    #   @return [String] the zero-padded id of the cinema, e.g. '017'

    # Vista site ids whose page slug differs from the cinema name
    URL_SLUGS = {
      '915' => 'dudley-merry-hill',
      '955' => 'manchester-trafford-centre'
    }.freeze

    # Constructor
    # @param [Integer, String] id the cinema id of the format 17/'017'
    # @return [OdeonUk::Cinema]
    def initialize(id)
      @id = id.to_s.rjust(3, '0')
    end

    # Return basic cinema information for all UK cinemas
    # @return [Array<OdeonUk::Cinema>]
    # @example
    #   OdeonUk::Cinema.all
    #   #=> [<OdeonUk::Cinema>, <OdeonUk::Cinema>, ...]
    def self.all
      sites_hash.keys.map { |cinema_id| new(cinema_id) }
    end

    # @!method address
    #   Address of the cinema
    #   @return [Hash] of different address parts
    #   @see #adr

    # Address of the cinema
    # @return [Hash] contains :street_address, :extended_address,
    # :locality, :postal_code, :country
    # @example
    #   cinema = OdeonUk::Cinema.new(824)
    #   cinema.adr
    #   #=> {
    #         street_address: 'Kingswest',
    #         extended_address: 'West Street',
    #         locality: 'Brighton',
    #         region: nil,
    #         postal_code: nil,
    #         country_name: 'United Kingdom'
    #       }
    # @note Uses the standard method naming as at http://microformats.org/wiki/adr
    # @note The API does not supply postcodes
    def adr
      address = site_hash.dig('contactDetails', 'address') || {}
      {
        street_address:   address['line1'],
        extended_address: address['line2'],
        locality:         address['city'],
        region:           nil,
        postal_code:      nil,
        country_name:     'United Kingdom'.freeze
      }
    end

    # Brand of the cinema
    # @return [String] which will always be 'Odeon'
    # @example
    #   cinema = OdeonUk::Cinema.new(3)
    #   cinema.brand
    #   #=> 'Odeon'
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
      @name ||= site_name.gsub(/\ALondon /, '').gsub(' - ', ': ')
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
      "https://www.odeon.co.uk/cinemas/#{url_slug}/"
    end

    # @api private
    def self.sites_hash
      @sites_hash ||= OdeonUk::Internal::ApiResponse.new.sites.to_h do |site|
        [site.fetch('id'), site]
      end
    end
    private_class_method :sites_hash

    private

    def site_hash
      @site_hash ||= self.class.send(:sites_hash).fetch(id, {})
    end

    def site_name
      site_hash.dig('name', 'text').to_s
    end

    def url_slug
      URL_SLUGS.fetch(id) do
        site_name.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/\A-|-\z/, '')
      end
    end
  end
end

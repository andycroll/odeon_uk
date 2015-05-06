module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Api
    # The object representing a cinema on the Odeon UK website
    class Cinema
      # @return [Integer] the numeric id of the cinema via the API
      attr_reader :id

      # @param [Integer, String] id cinema id
      # @return [OdeonUk::Cinema]
      def initialize(id)
        @id = id.to_i
      end

      # Return basic cinema information for all cinemas
      # @return [Array<OdeonUk::Cinema>]
      def self.ids
        cinemas_hash.keys.map(&:to_i)
      end

      # The locality (town) of the cinema
      # @return [String]
      def locality
        cinema_hash['siteAddress2']
      end

      # The name of the cinema
      # @return [String]
      def name
        cinema_hash['siteName']
      end

      # The url of the cinema
      # @return [Nil]
      def url
        "http://www.odeon.co.uk/cinemas/#{urlized_name}/#{@id}/"
      end

      # Post code of the cinema
      # @return [String]
      def postal_code
        cinema_hash['sitePostcode']
      end

      # The street adress of the cinema
      # @return [String]
      def street_address
        cinema_hash['siteAddress1']
      end

      private

      def self.cinemas_hash
        @@cinemas_hash ||= Api::Response.new.all_cinemas['sites']
      end

      def cinema_hash
        @cinema_hash ||= self.class.cinemas_hash[id.to_s]
      end

      def urlized_name
        name.downcase.gsub(/[^a-z0-9]/, '_')
      end
    end
  end
end

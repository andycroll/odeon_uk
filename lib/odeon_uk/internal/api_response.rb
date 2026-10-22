# frozen_string_literal: true

require "date"

module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Fetches cinema and showtime data from the Vista API behind odeon.co.uk
    class ApiResponse
      BASE_URL = "https://vwc.odeon.co.uk/WSVistaWebClient/ocapi/v1/"
      # Limits sites to the UK, leaving out ODEON's Irish cinemas.
      REGION_CODE = "UK"

      # @return [Array<Hash>] UK cinemas
      def sites
        client.get("sites").fetch("sites")
      end

      # @param [String] cinema_id zero-padded site id, e.g. '017'
      # @param [Date] date business date
      # @return [Hash] showtimes plus their related films and attributes
      def showtimes(cinema_id, date)
        client.get("showtimes/by-business-date/#{date.iso8601}",
                   "siteIds" => cinema_id)
      end

      private

      def client
        Cinebase::Vista::Client.new(base_url: BASE_URL, region_code: REGION_CODE,
                                    token: OdeonUk.token)
      end
    end
  end
end

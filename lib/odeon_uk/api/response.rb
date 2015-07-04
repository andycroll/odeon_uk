require 'cfpropertylist'
require 'net/http'

module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Api
    # Utility class to make calls to the odeon website
    class Response
      # iOS app API version
      VERSION = '2.1'

      # cinemas information
      # @return [Hash] decoded response of api containing cinema details
      def all_cinemas
        parse(all_cinemas_raw)
      end

      # application initialize
      # @return [Hash] decoded response of api, mostly films
      def app_init
        parse(app_init_raw)
      end

      # showings for a film at a cinema
      # @return [Hash] decoded response of api, day split times
      def film_times(cinema_id, film_id)
        parse(film_times_raw(cinema_id, film_id))
      end

      private

      def all_cinemas_raw
        post('all-cinemas').body
      end

      def app_init_raw
        post('app-init').body
      end

      def film_times_raw(cinema_id, film_id)
        post('film-times', { s: cinema_id, m: film_id }).body
      end

      def post(path, request_body={})
        uri = URI("https://api.odeon.co.uk/#{VERSION}/api/#{path}")
        Net::HTTP.post_form(uri, request_body)
      end

      def parse(content)
        plist = CFPropertyList::List.new(data: content)
        CFPropertyList.native_types(plist.value).fetch('data', {})
      end
    end
  end
end

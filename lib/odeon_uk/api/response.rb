require 'cfpropertylist'

module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Api
    # Utility class to make calls to the odeon website
    class Response
      VERSION = '2.1'

      # cinemas information
      # @return [Hash] decoded response of api containing cinema details
      def all_cinemas
        parse(post('all-cinemas').body).fetch('data', {})
      end

      # application initialize
      # @return [Hash] decoded response of api, mostly films
      def app_init
        parse(post('app-init').body).fetch('data', {})
      end

      # showings for a film at a cinema
      # @return [Hash] decoded response of api, day split times
      def film_times(cinema_id:, film_id:)
        response = post('film-times', { s: cinema_id, m: film_id }).body
        parse(response).fetch('data', {})
      end

      private

      def post(path, request_body={})
        uri = URI("https://api.odeon.co.uk/#{VERSION}/api/#{path}")
        Net::HTTP.post_form(uri, request_body)
      end

      def parse(content)
        plist = CFPropertyList::List.new(data: content)
        CFPropertyList.native_types(plist.value)
      end
    end
  end
end

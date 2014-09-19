require 'open-uri'

module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Utility class to make calls to the odeon website
    class Website
      # cinema page
      # @param [Integer] cinema_id website id of the cinema
      # @return [String] html of the page
      def cinema(cinema_id)
        get("cinemas/odeon/#{cinema_id}/")
      end

      # showtimes page for a single cinema
      # @param [Integer] cinema_id website id of the cinema
      # @return [String] html of the page
      def showtimes(cinema_id)
        get("showtimes/week/#{cinema_id}/?siteId=#{cinema_id}")
      end

      # sitemap page
      # @return [String] html of the page
      def sitemap
        get('sitemap/')
      end

      private

      def get(path)
        URI("http://www.odeon.co.uk/#{path}").read
      end
    end
  end
end

module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Parses a chunk of HTML to derive showing data for a single films
    class ShowtimesParser
      # css selector for film html chunks
      FILM_CSS = '.film-detail'

      # @param [Integer] cinema_id cineworld cinema id
      def initialize(cinema_id)
        @cinema_id = cinema_id
      end

      # break up the whats on page into individual chunks for each film
      # @return [Array<String>] html chunks for a film and it's screenings
      def films_with_screenings
        showtimes_doc.css(FILM_CSS).map { |n| n.to_s.gsub(/^\s+/, '') }
      end

      private

      def showtimes
        @showtimes ||= OdeonUk::Internal::Website.new.showtimes(@cinema_id)
      end

      def showtimes_doc
        @showtimes_doc ||= Nokogiri::HTML(showtimes)
      end
    end
  end
end

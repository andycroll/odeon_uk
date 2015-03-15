module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Html
    # The object representing a single screening of a film on the Odeon UK website
    class Screenings
      # css selector for film html chunks
      FILM_CSS = '.film-detail'

      # All currently listed films showing at a cinema
      # @param [Integer] cinema_id id of the cinema on the website
      # @return [Array<Hash>]
      def self.at(cinema_id)
        film_nodes(cinema_id).flat_map do |node|
          screenings_parser(node).to_a
        end
      end

      private

      def self.screenings_parser(html)
        Parser::FilmWithScreenings.new(html)
      end

      def self.film_nodes(id)
        showtimes_doc(id).css(FILM_CSS).map { |node| node.to_s.gsub(/^\s+/, '') }
      end

      def self.showtimes(id)
        OdeonUk::Html::Website.new.showtimes(id)
      end

      def self.showtimes_doc(id)
        Nokogiri::HTML(showtimes(id))
      end
    end
  end
end

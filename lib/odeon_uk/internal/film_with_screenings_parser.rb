module OdeonUk
  module Internal
    # Private: An object to parse a film HTML snippet
    class FilmWithScreeningsParser

      def initialize(film_html)
        @nokogiri_html = Nokogiri::HTML(film_html)
      end

      def name
        name = @nokogiri_html.css('.presentation-info h4 a').children.first.to_s
        name = name.gsub /\s+[23][dD]/, '' #remove 2d or 3d from title
        name = name.gsub 'Autism Friendly Screening -', '' # remove autism friendly
        name = name.gsub '(live)', '' # remove '(live)' for steamed performances
        name = name.gsub 'ROH -', 'Royal Opera House:' # fill out Royal Opera House
        name = name.gsub 'Met Opera -', 'Met Opera:' # fill out Met Opera
        name = name.squeeze(' ') # spaces compressed
        name = name.gsub /\A\s/, '' # remove leading spaces
        name = name.gsub /\s\z/, '' # remove trailing spaces
      end
    end
  end
end

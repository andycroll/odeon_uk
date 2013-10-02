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
        name = name.gsub /Cinemagic \d{1,4} \-/, '' # remove cinemagic stuff
        name = name.gsub 'UKJFF -', '' # remove UK Jewish festival prefix
        name = name.gsub 'NT Live -', 'National Theatre:' # National theatre
        name = name.gsub 'National Theatre Live -', 'National Theatre:'
        name = name.gsub /\(Encore.+\)/, '' # National theatre, remove encore
        name = name.gsub 'Bolshoi -', 'Bolshoi:' # bolshoi ballet
        name = name.gsub /\([Ll]ive\)/, '' # remove bolshoi-style live
        name = name.gsub 'Globe On Screen:', 'Globe:' # globe
        if name.match /RSC Live/
          name = 'Royal Shakespeare Company: ' + name.gsub(/\- RSC Live \d{1,4}/, '')
        end
        name = name.squeeze(' ') # spaces compressed
        name = name.gsub /\A\s+/, '' # remove leading spaces
        name = name.gsub /\s+\z/, '' # remove trailing spaces
      end
    end
  end
end

module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Html
    # Parses HTML with Nokogiri
    module Parser
      # Parses a chunk of HTML to derive movie showing data
      class FilmWithScreenings
        # CSS selector for a film title inside an individual film HTML
        NAME_CSS      = '.presentation-info h4 a'
        # CSS selector for a group of showtimes inside an individual film HTML
        SHOWTIMES_CSS = '.times-all.accordion-group'

        # @param [String] html a chunk of html
        def initialize(html)
          @html = html
        end

        # The film name
        # @return [String]
        def film_name
          @film_name ||= Internal::TitleSanitizer.new(raw_film_name).sanitized
        end

        # array containing hashes of screening attributes
        # @return [Array<Hash>]
        def to_a
          doc.css(SHOWTIMES_CSS).map do |node|
            dimension_parser(node).to_a.map do |hash|
              hash.merge(film_name: film_name)
            end
          end.flatten
        end

        private

        def doc
          @doc ||= Nokogiri::HTML(@html)
        end

        def raw_film_name
          @raw_film_name ||= doc.css(NAME_CSS).children.first.to_s
        end

        def dimension_parser(node)
          DimensionNodeParser.new(node)
        end
      end

      # parses chunk of screenings for a particular screening dimension
      class DimensionNodeParser
        # CSS selector for a single screening inside a 'group of showtimes' HTML
        SCREENING_CSS = '.show'
        # CSS selector for showing technology for a 'group of showtimes' HTML
        TECH_CSS = '.tech a'

        # @param [Nokigiri::Node] node a Nokogiri node object
        def initialize(node)
          @node = node
        end

        # array containing hashes of screening attributes for dimension
        # @return [Array<Hash>]
        def to_a
          screening_hashes.map do |hash|
            hash.merge(dimension: dimension,
                       variant:   add_imax(hash[:variant]))
          end
        end

        private

        def add_imax(original)
          imax? ? "#{original} imax".strip : original
        end

        def dimension
          dimension_from_tech || '2d'
        end

        def dimension_from_tech
          tech.match(/[23]d/i) { |data| data[0] }
        end

        def imax?
          !!tech.match(/imax/)
        end

        def screening_hashes
          screening_nodes.map { |node| ScreeningNodeParser.new(node).to_hash }
        end

        def screening_nodes
          @node.css(SCREENING_CSS)
        end

        def tech
          @tech ||= @node.css(TECH_CSS).text.gsub('in ', '').downcase
        end
      end

      # parses a single screening
      class ScreeningNodeParser
        # regex for time format
        TIME_REGEX = %r(\d+/\d+/\d+ \d{2}\:\d{2})
        # regex for D-Box screenings
        DBOX_REGEX = /D-Box/

        # @param [Nokigiri::Node] node a Nokogiri node object
        def initialize(node)
          @node = node
        end

        # hashes of screening attributes
        # @return [Hash]
        def to_hash
          {
            booking_url: booking_url,
            time:        utc_time,
            variant:     variant
          }
        end

        private

        def booking_url
          link_attr('href').to_s
        end

        def link_attr(attribute)
          @node.css('a').attribute(attribute)
        end

        def info
          @node.css('i').to_s
        end

        def time
          Time.parse(time_string)
        end

        def time_string
          link_attr('title').to_s.match(TIME_REGEX).to_s + ' UTC'
        end

        def tz
          @tz ||= TZInfo::Timezone.get('Europe/London')
        end

        def utc_time
          tz.local_to_utc(time)
        end

        def variant
          info.match(DBOX_REGEX) ? 'd-box' : ''
        end
      end
    end
  end
end

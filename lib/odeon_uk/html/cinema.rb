module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Html
    # The object representing a cinema on the Odeon UK website
    class Cinema
      ADDRESS_REGEX = '.gethere .span4 .description'
      ALL_LINKS =     '.sitemap a[href*=cinemas]'

      # @return [Integer] the numeric id of the cinema on the Odeon website
      attr_reader :id

      # @param [Integer, String] id cinema id
      # @return [OdeonUk::Cinema]
      def initialize(id)
        @id = id.to_i
      end

      # Return basic cinema information for all cinemas
      # @return [Array<OdeonUk::Cinema>]
      def self.ids
        cinema_links.map { |link| id_from(link) }
      end

      # The locality (town) of the cinema
      # @return [String]
      def locality
        return unless address_node
        address_node.text.match(/\w+(\s\w+){0,}\s+(\w+(\s\w+){0,})/)[2]
      end

      # The name of the cinema
      # @return [String]
      def name
        cinema_link_doc.children.first.to_s
      end

      # The web url of the cinema
      # @return [String]
      def url
        @url ||= begin
          link = cinema_link_doc.get_attribute('href')
          (link[0] == '/') ? "http://www.odeon.co.uk#{link}" : link
        end
      end

      # Post code of the cinema
      # @return [String]
      def postal_code
        return unless address_node
        address_node.text.match(/[A-Z]{1,2}\d{1,2}[A-Z]?\s\d{1,2}[A-Z]{1,2}/)[0]
      end

      # The street adress of the cinema
      # @return [String]
      def street_address
        return unless address_node
        address_node.text.match(/\A\s+(\w+(\s\w+){0,})/)[1]
      end

      private

      def self.id_from(link)
        link.get_attribute('href').match(/\/(\d+)\/$/)[1].to_i
      end

      def self.cinema_links
        @@cinema_links ||= begin
          links = sitemap_doc.css(ALL_LINKS)
          links.select { |link| link.get_attribute('href').match(/\/\d+\/$/) }
        end
      end

      def self.sitemap_doc
        @@sitemap_doc ||= Nokogiri::HTML(sitemap_response)
      end

      def self.sitemap_response
        @@sitemap_response ||= Html::Website.new.sitemap
      end

      def address_node
        cinema_doc.css(ADDRESS_REGEX)[0]
      end

      def cinema_response
        @cinema_response ||= Html::Website.new.cinema(id)
      end

      def cinema_doc
        @cinema_doc ||= Nokogiri::HTML(cinema_response)
      end

      def cinema_link_doc
        self.class.cinema_links.select do |link|
          link.get_attribute('href').include?("/#{id}/")
        end.first
      end
    end
  end
end

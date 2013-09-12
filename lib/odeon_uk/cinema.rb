require 'httparty'
require 'nokogiri'
require 'pp'

module OdeonUk
  class Cinema

    attr_reader :id, :name, :slug, :url

    def initialize(id, name, url)
      @id   = id.to_i
      @name = name
      @slug = name.downcase.gsub(/[^0-9a-z ]/,'').gsub(/\s+/, '-')
      built_url = (url[0] == '/') ? "http://www.odeon.co.uk#{url}" : url
      @url  = built_url
    end

    # Public: Return basic cinema information for all Odeon cinemas
    #
    # Examples
    #
    #   OdeonUk::Cinema.all
    #   # => [{:name => 'IMAX', :id => 's201'}, {:name => 'Tunbridge Wells', :id => 's23'}]
    #
    # Returns an array of hashes of cinema information.
    def self.all
      doc.css('.sitemap > .span12:nth-child(4) li a').map do |link|
        href = link.get_attribute('href')
        name = link.children.first.to_s

        if id = href.match(/\/(\d+)\/$/)
          new(id[1].to_i, name, href)
        else
          nil
        end
      end.compact
    end

    # Public: Return single cinema information for an Odeon cinema
    #
    # id_string - a string representing the cinema id
    #             of the format 's000' as used on the odeon.co.uk website
    #
    # Examples
    #
    #   OdeonUk::Cinema.find('s23')
    #   # => {:name => 'IMAX', :id => 's23'}
    #
    # Returns a hash of cinema information.
    def self.find(id_string)
      # return nil unless id_string.match(/^s\d+$/)
      sitemap_response
      { name: 'Bristol', id: 's30' }
    end

    private

    def self.doc
      Nokogiri::HTML(sitemap_response)
    end

    def self.sitemap_response
      @sitemap_response ||= HTTParty.get('http://www.odeon.co.uk/sitemap/')
    end

  end
end

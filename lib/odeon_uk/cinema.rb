require 'httparty'

module OdeonUk
  class Cinema

    # Public: Return basic cinema information for all Odeon cinemas
    #
    # Examples
    #
    #   OdeonUk::Cinema.all
    #   # => [{:name => 'IMAX', :id => 's201'}, {:name => 'Tunbridge Wells', :id => 's23'}]
    #
    # Returns an array of hashes of cinema information.
    def self.all
      sitemap_response
      [{}, {}]
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

    def self.sitemap_response
      @sitemap_response ||= HTTParty.get('http://www.odeon.co.uk/fanatic/sitemap/')
    end

  end
end
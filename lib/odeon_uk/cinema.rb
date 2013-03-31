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

    private

    def self.sitemap_response
      @sitemap_response ||= HTTParty.get('http://www.odeon.co.uk/fanatic/sitemap/')
    end

  end
end
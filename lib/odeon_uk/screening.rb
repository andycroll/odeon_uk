require 'httparty'
require 'nokogiri'

module OdeonUk

  # Public: The object representing a screening of a film on the Odeon UK website
  class Screening

    # Public: Returns the String name of the cinema
    attr_reader :cinema_name
    # Public: Returns the String name of the film
    attr_reader :film_name
    # Public: Returns the Time of the screening
    attr_reader :when
    # Public: Returns the Type of screening (3d, baby, kids, live)
    attr_reader :varient

    def initialize(film_name, cinema_name, date, time, varient=nil)
      @cinema_name, @film_name, @varient = cinema_name, film_name, varient
      @when = Time.parse("#{date} #{time}")
    end

  end
end

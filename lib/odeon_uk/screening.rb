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

    # Public: Initialize a screening
    #
    # film_name   - String of the film name
    # cinema_name - String of the cinema name on the Odeon website
    # date        - String/Date representing the date of the screening
    # time        - String representing the time of the screening (24 hour clock)
    # varient     - String representing the type of showing (e.g. 3d/baby/live)
    def initialize(film_name, cinema_name, date, time, varient=nil)
      @cinema_name, @film_name, @varient = cinema_name, film_name, varient
      @when = Time.parse("#{date} #{time} UTC")
    end

    # Public: The Date of the screening
    #
    # Returns a Date
    def date
      @when.to_date
    end

    # Public: The string representation of the date of the screening
    #
    # Returns a String
    def date_s
      date.to_s
    end

    # Public: The string representation of the time of the screening
    #
    # Returns a String
    def time_s
      "#{@when.hour}:#{@when.min}"
    end
  end
end

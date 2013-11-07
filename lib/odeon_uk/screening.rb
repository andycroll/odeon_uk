module OdeonUk

  # The object representing a single screening of a film on the Odeon UK website
  class Screening

    # @return [String] the booking URL on the cinema website
    attr_reader :booking_url
    # @return [String] the cinema name
    attr_reader :cinema_name
    # @return [String] the film name
    attr_reader :film_name
    # @return [Time] the UTC time of the screening
    attr_reader :when
    # @return [String] the type of screening (2D, 3D, IMAX...)
    attr_reader :varient

    # @param [String] film_name the film name
    # @param [String] the cinema name
    # @param [Time] time datetime of the screening (UTC preferred)
    # @param [String] booking_url direct link to the booking page for this screening
    # @param [String] varient the type of showing (e.g. 3d/baby/live)
    def initialize(film_name, cinema_name, time, booking_url=nil, varient=nil)
      @cinema_name, @film_name, @varient = cinema_name, film_name, varient
      @booking_url = booking_url
      @when = time.utc? ? time : TZInfo::Timezone.get('Europe/London').local_to_utc(time)
    end

    # The date of the screening
    # @return [Date]
    def date
      @when.to_date
    end
  end
end

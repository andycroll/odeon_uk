module OdeonUk
  # The object representing a single screening of a film on the Odeon UK website
  class Screening
    # @return [String] the booking URL on the cinema website
    attr_reader :booking_url
    # @return [String] 2d or 3d
    attr_reader :dimension
    # @return [String] the cinema name
    attr_reader :cinema_name
    # @return [String] the film name
    attr_reader :film_name

    # @param [Hash] options options hash
    # @option options [String] :booking_url (nil) booking url for the screening
    # @option options [String] :cinema_name name of the cinema
    # @option options [String] :cinema_id website id of the cinema
    # @option options [String] :dimension ('2d') dimension of the screening
    # @option options [String] :film_name name of the film
    # @option options [Time] :time utc time of the screening
    # @option options [Array<String>] :variant ([]) type of screening
    def initialize(options)
      @booking_url = options.fetch(:booking_url, nil)
      @cinema_name = options.fetch(:cinema_name)
      @cinema_id   = options.fetch(:cinema_id)
      @dimension   = options.fetch(:dimension, '2d')
      @film_name   = options.fetch(:film_name)
      @time        = options.fetch(:time)
      @variant     = options.fetch(:variant, [])
    end

    # All currently listed films showing at a cinema
    # @param [Integer] cinema_id id of the cinema on the website
    # @return [Array<OdeonUk::Screening>]
    def self.at(cinema_id)
      showtimes_page(cinema_id).to_a.map do |html|
        screenings_parser(html).to_a.map do |attributes|
          new(attributes.merge(cinema_hash(cinema_id)))
        end
      end.flatten
    end

    # The date of the screening
    # @return [Date]
    def showing_on
      showing_at.to_date
    end

    # The UTC time of the screening
    # @return [Time]
    def showing_at
      @time
    end

    # The kinds of screening
    # @return <Array[String]>
    def variant
      @variant = @variant.split(' ') if @variant.is_a?(String)
      @variant.map(&:downcase).sort
    end

    private

    def self.screenings_parser(html)
      OdeonUk::Internal::FilmWithScreeningsParser.new(html)
    end

    def self.showtimes_page(cinema_id)
      OdeonUk::Internal::ShowtimesPage.new(cinema_id)
    end

    def self.cinema_hash(id)
      { cinema_id: id, cinema_name: Cinema.find(id).name }
    end
  end
end

module OdeonUk
  # The object representing a single screening of a film on the Odeon UK website
  class Performance < Cinebase::Performance
    # @!attribute [r] booking_url
    #   @return [String] the booking URL on the cinema website
    # @!attribute [r] cinema_name
    #   @return [String] the cinema name
    # @!attribute [r] cinema_id
    #   @return [String] the cinema id
    # @!attribute [r] dimension
    #   @return [String] 2d or 3d
    # @!attribute [r] film_name
    #   @return [String] the film name

    # @!method initialize(options)
    #   @param [Hash] options options hash
    #   @option options [String] :booking_url (nil) buying url for the screening
    #   @option options [String] :cinema_name name of the cinema
    #   @option options [String] :cinema_id website id of the cinema
    #   @option options [String] :dimension ('2d') dimension of the screening
    #   @option options [String] :film_name name of the film
    #   @option options [Time] :starting_at listed start time of the performance

    # All currently listed films showing at a cinema
    # @param [Integer] cinema_id id of the cinema on the website
    # @return [Array<OdeonUk::Performance>]
    def self.at(cinema_id)
      film_ids_at(cinema_id).flat_map do |film_id|
        api_response.film_times(cinema_id, film_id).flat_map do |day|
          performance_days(day).map do |hash|
            new(hash.merge(cinema_hash(cinema_id))
                    .merge(film_name: film_name(film_id)))
          end
        end
      end
    end

    # @!method showing_on
    #   The date of the screening
    #   @return [Date]

    # @!method starting_at
    #   UTC time of the screening
    #   @return [Time]

    # @!method variant
    #   The kinds of screening (IMAX, kids, baby, senior)
    #   @return <Array[String]>

    # private

    def self.api_response
      @api_response ||= OdeonUk::Internal::ApiResponse.new
    end
    private_class_method :api_response

    def self.cinema_hash(cinema_id)
      { cinema_id: cinema_id, cinema_name: Cinema.new(cinema_id).name }
    end
    private_class_method :cinema_hash

    def self.films_at(cinema_id)
      film_lookup.at(cinema_id)
    end
    private_class_method :films_at

    def self.film_lookup
      @film_lookup ||= OdeonUk::Internal::Parser::Api::FilmLookup.new
    end
    private_class_method :film_lookup

    def self.film_ids_at(cinema_id)
      films_at(cinema_id).keys
    end
    private_class_method :film_ids_at

    def self.film_name(film_id)
      film_lookup.to_hash[film_id]['title']
    end
    private_class_method :film_name

    def self.performance_days(data)
      OdeonUk::Internal::Parser::Api::PerformanceDay.new(data).to_a
    end
    private_class_method :performance_days
  end
end

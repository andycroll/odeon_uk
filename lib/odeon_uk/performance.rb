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
    #   @option options [Cinebase::Festival] :festival (nil) festival edition
    #   @option options [String] :language (nil) audio language of the screening

    # Performances within an inclusive range of cinema business dates.
    # @param [Integer, String] cinema_id id of the cinema on the website
    # @param [Date] from first date (defaults to today in London)
    # @param [Date] to last date (defaults to 13 days after from)
    # @return [Array<OdeonUk::Performance>]
    def self.at(
      cinema_id,
      from: TZInfo::Timezone.get('Europe/London').now.to_date,
      to: from + 13
    )
      raise ArgumentError, 'to must not precede from' if to < from

      api = OdeonUk::Internal::ApiResponse.new
      cinema = Cinema.new(cinema_id)
      (from..to).flat_map do |date|
        performances_on(api, cinema, date)
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

    def self.performances_on(api, cinema, date)
      response = api.showtimes(cinema.id, date)
      related = response.fetch('relatedData')
      films = by_id(related.fetch('films'))
      attributes = by_id(related.fetch('attributes'))

      response.fetch('showtimes').map do |data|
        showtime = OdeonUk::Internal::Parser::Api::Showtime.new(
          data, films: films, attributes: attributes
        )
        new(showtime.to_hash.merge(cinema_id: cinema.id,
                                   cinema_name: cinema.name))
      end
    end
    private_class_method :performances_on

    def self.by_id(items)
      items.to_h { |item| [item.fetch('id'), item] }
    end
    private_class_method :by_id
  end
end

require 'pry'
module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Api
    # The object representing a single screening of a film via the Odeon UK api
    class Screenings
      # All currently listed screenings at a cinema
      # @param [Integer] cinema_id id of the cinema
      # @return [Array<Hash>]
      def self.at(cinema_id)
        film_ids(cinema_id).flat_map do |film_id|
          times_response = response.film_times(cinema_id, film_id)

          times_response.flat_map do |day|
            date =         day['date']
            screenings =   day['attributes']

            screenings.flat_map do |screening|
              performances = screening['showtimes']

              performances.flat_map do |p|
                {
                  dimension: screening['attribute'].include?('3D') ? '3d' : '2d',
                  film_name: films_map(cinema_id)[film_id],
                  time:      TimeParser.new(date, p[0]['performanceTime']).to_utc,
                  variant:   '',
                }
              end
            end
          end
        end
      end

      private

      def self.app_init
        @@app_init ||= Response.new.app_init
      end

      def self.film_ids(cinema_id)
        films_map(cinema_id).keys
      end

      def self.films_map(cinema_id)
        films_at(cinema_id).each_with_object({}) do |f, result|
          result[f['filmMasterId']] = f['title']
        end
      end

      def self.films_at(cinema_id)
        app_init['films'].select { |f| f['sites'].include?(cinema_id) }
      end

      def self.response
        @@response ||= Response.new
      end
    end

    TimeParser = Struct.new(:date, :time) do
      def to_utc
        tz.local_to_utc(parsed_time)
      end

      private

      def early_morning_screening?
        !!time.match(/\A0/)
      end

      def parsed_date
        case date
        when 'Today'    then Time.now.strftime '%Y-%m-%d'
        when 'Tomorrow' then (Time.now + 60 * 60 * 24).strftime '%Y-%m-%d'
        else date.gsub('.', '').match(/\d+\s\w+\z/)[0]
        end
      end

      def parsed_time
        parsed_time = Time.parse("#{parsed_date} #{time} UTC")
        # Odeon deliberately mislabel their 00:01 screenings as the day before
        early_morning_screening? ? parsed_time + 60 * 60 * 24 : parsed_time
      end

      def tz
        @tz ||= TZInfo::Timezone.get('Europe/London')
      end
    end
  end
end

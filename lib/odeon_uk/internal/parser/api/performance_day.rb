module OdeonUk
  # @api private
  module Internal
    module Parser
      module Api
        # A single day of performances for a particular film
        class PerformanceDay
          def initialize(data)
            @data = data
          end

          def to_a
            performance_kinds.each_with_index.flat_map do |_, index|
              starting_times(index).map do |time|
                {
                  dimension: dimension(index),
                  starting_at: TimeParser.new(date, time).to_utc,
                  variant: variant(index)
                }
              end
            end
          end

          private

          def date
            @data['date']
          end

          def dimension(index)
            performance_kind(index).include?('3D') ? '3d' : '2d'
          end

          def performance_kinds
            @data['attributes']
          end

          def performance_kind(index)
            performance_kinds[index]['attribute']
          end

          def starting_times(index)
            performance_kinds[index]['showtimes'][0].map do |h|
              h['performanceTime']
            end
          end

          def variant(index)
            {
              'Culture'       => 'arts',
              'Kids'          => 'kids',
              'IMAX'          => 'imax',
              'Newbies'       => 'baby',
              'Silver Cinema' => 'senior'
            }.select { |k, _| performance_kind(index).include?(k) }.values.uniq
          end

          # parse a time to utc time
          TimeParser = Struct.new(:date, :time) do
            def to_utc
              tz.local_to_utc(parsed_time)
            end

            private

            def early_morning_screening?
              time.match(/\A00/)
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
    end
  end
end

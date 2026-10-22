# frozen_string_literal: true

require "time"

module OdeonUk
  # @api private
  module Internal
    module Parser
      module Api
        # Parses a single Vista showtime into performance attributes
        class Showtime
          BOOKING_URL = "https://www.odeon.co.uk/ticketing/seat-picker/?showtimeId="

          # Vista attribute short names
          VARIANTS = {
            "AudioDes" => "audio_described",
            "AutFriend" => "autism_friendly",
            "EnglishSub" => "subtitled",
            "EventCinem" => "arts",
            "IMAX" => "imax",
            "Newbies" => "baby",
            "ODEON Kids" => "kids",
            "OpenCapt" => "subtitled",
            "SilverCine" => "senior"
          }.freeze

          # @param [Hash] data one showtime
          # @param [Hash{String => Hash}] films related films keyed by id
          # @param [Hash{String => Hash}] attributes related attributes keyed by id
          def initialize(data, films:, attributes:)
            @data = data
            @films = films
            @attributes = attributes
          end

          # @return [Hash] options for OdeonUk::Performance.new
          def to_hash
            {
              booking_url: BOOKING_URL + @data.fetch("id"),
              dimension: @data["requires3dGlasses"] ? "3d" : "2d",
              festival: Cinebase::Festival.from_title(title, year: starting_at.year),
              film_name: film_name,
              language: language,
              starting_at: starting_at,
              variant: variant
            }
          end

          private

          def attribute_names(key)
            @data.fetch("attributeIds", []).filter_map do |id|
              @attributes.dig(id, key, "text")
            end
          end

          def starting_at
            Time.iso8601(@data.dig("schedule", "startsAt")).utc
          end

          def film_name
            TitleSanitizer.new(title).sanitized
          end

          def title
            @films.fetch(@data.fetch("filmId")).dig("title", "text")
          end

          def language
            attribute_names("name").filter_map { |name| name[/\A(.+) \(Audio\)\z/, 1] }.first
          end

          def variant
            attribute_names("shortName").filter_map { |name| VARIANTS[name] }.uniq
          end
        end
      end
    end
  end
end

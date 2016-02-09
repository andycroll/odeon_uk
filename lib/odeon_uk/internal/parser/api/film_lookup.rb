module OdeonUk
  # @api private
  module Internal
    module Parser
      module Api
        # Parses a string to derive address
        class FilmLookup
          # @param [Integer] cinema_id id of the cinema
          # @return [Hash{Integer => OdeonUk::Internal::Parser::Api::Film}]
          # contains all films keyed by id for a cinema
          def at(cinema_id)
            to_hash.select do |_, film_hash|
              film_hash['sites'].include?(cinema_id)
            end
          end

          # @return [Hash{Integer => OdeonUk::Internal::Parser::Api::Film}]
          # contains all films & upcoming films keyed by id
          def to_hash
            @to_hash ||= api.each_with_object({}) do |film_hash, result|
              result[film_hash['filmMasterId'].to_i] = film_hash
            end
          end

          private

          def api
            @api ||= OdeonUk::Internal::ApiResponse.new.app_init['films']
          end
        end
      end
    end
  end
end

require 'cinebase'

require_relative './odeon_uk/version'

require_relative './odeon_uk/internal/api_response'
require_relative './odeon_uk/internal/title_sanitizer'

require_relative './odeon_uk/internal/parser/api/film_lookup'
require_relative './odeon_uk/internal/parser/api/performance_day'

require_relative './odeon_uk/cinema'
require_relative './odeon_uk/performance'

# odeon_uk gem
module OdeonUk
end

require 'nokogiri'
require 'tzinfo'
require 'tzinfo/data'

require_relative './odeon_uk/version'

require_relative './odeon_uk/internal/film_with_screenings_parser'
require_relative './odeon_uk/internal/showtimes_page'
require_relative './odeon_uk/internal/title_sanitizer'
require_relative './odeon_uk/internal/website'

require_relative './odeon_uk/cinema'
require_relative './odeon_uk/film'
require_relative './odeon_uk/screening'

# odeon_uk gem
module OdeonUk
end

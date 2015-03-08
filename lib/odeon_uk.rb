require 'nokogiri'
require 'tzinfo'
require 'tzinfo/data'

require_relative './odeon_uk/version'

require_relative './odeon_uk/internal/title_sanitizer'

require_relative './odeon_uk/html/parser/film_with_screenings'
require_relative './odeon_uk/html/parser/showtimes_page'
require_relative './odeon_uk/html/website'
require_relative './odeon_uk/html/cinema'
require_relative './odeon_uk/html/film'
require_relative './odeon_uk/html/screening'

# odeon_uk gem
module OdeonUk
end

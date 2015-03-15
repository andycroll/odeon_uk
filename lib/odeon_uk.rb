require 'forwardable'
require 'nokogiri'
require 'tzinfo'
require 'tzinfo/data'

require_relative './odeon_uk/version'
require_relative './odeon_uk/configuration'

require_relative './odeon_uk/internal/title_sanitizer'

require_relative './odeon_uk/api/response'
require_relative './odeon_uk/api/cinema'
require_relative './odeon_uk/api/screenings'

require_relative './odeon_uk/html/parser/film_with_screenings'
require_relative './odeon_uk/html/website'
require_relative './odeon_uk/html/cinema'
require_relative './odeon_uk/html/screenings'

require_relative './odeon_uk/cinema'
require_relative './odeon_uk/screening'

# odeon_uk gem
module OdeonUk
end

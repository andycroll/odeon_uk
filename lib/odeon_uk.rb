require 'forwardable'
require 'nokogiri'
require 'tzinfo'
require 'tzinfo/data'

require_relative './odeon_uk/version'

require_relative './odeon_uk/internal/api_response'
require_relative './odeon_uk/internal/title_sanitizer'

require_relative './odeon_uk/api/cinema'
require_relative './odeon_uk/api/screenings'

require_relative './odeon_uk/cinema'
require_relative './odeon_uk/screening'

# odeon_uk gem
module OdeonUk
end

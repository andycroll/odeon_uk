require 'json'

require 'cinebase'
require 'cinebase/vista'

require_relative './odeon_uk/version'

require_relative './odeon_uk/internal/api_response'
require_relative './odeon_uk/internal/guest_token'
require_relative './odeon_uk/internal/title_sanitizer'

require_relative './odeon_uk/internal/parser/api/showtime'

require_relative './odeon_uk/cinema'
require_relative './odeon_uk/performance'

# odeon_uk gem
module OdeonUk
  AuthenticationError = Cinebase::Vista::AuthenticationError

  extend Cinebase::Vista::TokenHolder

  # @api private
  def self.guest_token_class
    Internal::GuestToken
  end
end

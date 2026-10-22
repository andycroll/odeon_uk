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

  # A raw guest JWT, without the "Bearer " prefix. Never persisted by the gem.
  class << self
    attr_accessor :token

    # Explicit acquisition/renewal; ordinary API calls never launch a subprocess.
    def acquire_token!(curl: nil)
      self.token = Internal::GuestToken.new(curl: curl).fetch
    end
  end
end

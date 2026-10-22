# frozen_string_literal: true

require "json"

module OdeonUk
  module Internal
    # Reads the public guest token from the ODEON website's page data
    class GuestToken < Cinebase::Vista::GuestToken
      # Every other page redirects to the queue-it waiting room first.
      PAGE_URL = "https://www.odeon.co.uk/my-account/"

      private

      def bundled_curl
        File.expand_path("../../../vendor/curl-impersonate/bin/curl-impersonate", __dir__)
      end

      def extract_token(html)
        JSON.parse(html[/window\.initialData\s*=\s*(.+?);\s*$/, 1].to_s).dig("api", "authToken")
      end
    end
  end
end

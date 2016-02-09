module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer < Cinebase::TitleSanitizer
      # @!method initialize(title)
      #   @param [String] title a film title
      #   @return [CineworldUk::Internal::TitleSanitizer]

      # @!method sanitized
      #   sanitized and standardized title
      #   @return [String] sanitised title

      private

      # strings and regex to be removed
      def remove
        [
          /\s+[23][dD]/,                 # dimension
          'Autism Friendly Screening -', # autism screening
          /\ACinemagic \d{1,4} \-/,      # cinemagic
          /\(encore.+\)/i,               # encore for NT Live
          /\(live\)/i,                   # live in brackets
          'UKJFF -',                     # UK Jewish festival prefix
          /\bsing\-?a\-?long\b/i,        # singalong
          'Autism Friendly - ',          # autism friendly
          'amp;',                        # html ampersands
        ]
      end

      # regexes and their replacements
      def replace
        {
          /Bolshoi - (.*)/               => 'Bolshoi: ',
          /Globe On Screen: (.*)/        => 'Globe: ',
          /Met Opera - (.*)/             => 'Met Opera: ',
          /National Theatre Live - (.*)/ => 'National Theatre: ',
          /NT Live - (.*)/               => 'National Theatre: ',
          /ROH - (.*)/                   => 'Royal Opera House: ',
          /(.*)\- RSC Live \d{1,4}/      => 'Royal Shakespeare Company: '
        }
      end
    end
  end
end

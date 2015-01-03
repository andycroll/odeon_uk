module OdeonUk
  # Internal utility classes: Do not use
  # @api private
  module Internal
    # Sanitize and standardize film titles
    class TitleSanitizer
      # strings and regex to be removed
      REMOVE = [
        /\s+[23][dD]/,                 # dimension
        'Autism Friendly Screening -', # autism screening
        /\ACinemagic \d{1,4} \-/,      # cinemagic
        /\(encore.+\)/i,               # encore for NT Live
        /\(live\)/i,                   # live in brackets
        'UKJFF -',                     # UK Jewish festival prefix
        /\bsing\-?a\-?long\b/i,        # singalong
      ]

      # regexes and their replacements
      REPLACE = {
        /Bolshoi - (.*)/               => 'Bolshoi: ',
        /Globe On Screen: (.*)/        => 'Globe: ',
        /Met Opera - (.*)/             => 'Met Opera: ',
        /National Theatre Live - (.*)/ => 'National Theatre: ',
        /NT Live - (.*)/               => 'National Theatre: ',
        /ROH - (.*)/                   => 'Royal Opera House: ',
        /(.*)\- RSC Live \d{1,4}/      => 'Royal Shakespeare Company: '
      }

      # @param [String] title a film title
      def initialize(title)
        @title = title
      end

      # sanitized and standardized title
      # @return [String] title
      def sanitized
        @sanitzed ||= begin
          sanitized = @title
          REMOVE.each do |pattern|
            sanitized.gsub! pattern, ''
          end
          REPLACE.each do |pattern, prefix|
            sanitized.gsub!(pattern) { |_| prefix + $1 }
          end
          sanitized.squeeze(' ').strip
        end
      end
    end
  end
end

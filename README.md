# OdeonUk

A simple gem to pull cinemas and performances from the Vista API behind the [ODEON UK website](https://www.odeon.co.uk) and spit out useful formatted info.

[![Gem Version](https://badge.fury.io/rb/odeon_uk.svg)](https://badge.fury.io/rb/odeon_uk)
[![Inline docs](http://inch-ci.org/github/andycroll/odeon_uk.svg?branch=master)](http://inch-ci.org/github/andycroll/odeon_uk)

## Installation

Add this line to your application's Gemfile:

    gem 'odeon_uk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install odeon_uk

## Usage

The gem conforms to the API set down in the `cinebase` gem, [andycroll/cinebase](https://github.com/andycroll/cinebase), which provides a lot of useful base vocabulary and repetitive code for this series of cinema focussed gems.

Performance titles are sanitized as much as possible, removing 'screening type' information and 'dimension' as well as standardising all the theatre/cultural event naming (NT Live, Royal Ballet and Opera etc).

### Guest token

Every API call needs the public guest token the ODEON website gives each
visitor. Fetch one before anything else:

``` ruby
OdeonUk.acquire_token!
OdeonUk::Cinema.all
```

This shells out to **`curl-impersonate`**, not ordinary system `curl`, using its
Chrome 150 TLS/HTTP profile, and reads `window.initialData.api.authToken` from
`https://www.odeon.co.uk/my-account/`. That page skips the queue-it waiting room
every other page redirects to. No browser or JavaScript execution is needed.

Platform-specific gem packages include the pinned `curl-impersonate` 2.2.3
executable for glibc Linux (x86-64, ARM64) and macOS (Intel, Apple Silicon).
On other platforms, or when installing from Git, install a
[curl-impersonate release](https://github.com/lexiforest/curl-impersonate/releases/tag/v2.2.3)
yourself and put it on your `PATH` or pass its path:

``` ruby
OdeonUk.acquire_token!(curl: '/opt/curl-impersonate/curl-impersonate')
```

Or supply your own current guest JWT, without the `Bearer ` prefix:

``` ruby
OdeonUk.token = ENV.fetch('ODEON_TOKEN')
```

Tokens currently last 12 hours. The gem checks the declared expiry but does not
verify the signature. Missing, expired or rejected tokens raise
`OdeonUk::AuthenticationError`; call `OdeonUk.acquire_token!` again. Normal API
calls never acquire or renew a token automatically.

### Cinema

Only UK cinemas are returned; ODEON's Irish cinemas are left out. Cinema ids
changed with the move to the Vista API (Brighton was 71 and is now 824). The API
does not supply postcodes, so `postal_code` is empty.

``` ruby
OdeonUk::Cinema.all
#=> [<OdeonUk::Cinema ...>, <OdeonUk::Cinema ...>, ...]

cinema = OdeonUk::Cinema.new(824)
#=> <OdeonUk::Cinema ...>

cinema.adr
#=> {
  street_address:   'Kingswest',
  extended_address: 'West Street',
  locality:         'Brighton',
  region:           nil,
  postal_code:      nil,
  country_name:     'United Kingdom'
}

cinema.brand
#=> 'Odeon'

cinema.full_name
#=> 'Odeon Brighton'

cinema.id
#=> '824'

cinema.url
#=> 'https://www.odeon.co.uk/cinemas/brighton/'
```

### Performances

`Performance.at` returns performances for an inclusive range of business dates,
defaulting to today in London and the following 13 days. It makes one request per
day.

``` ruby
OdeonUk::Performance.at(824)
#=> [<OdeonUk::Performance ...>, <OdeonUk::Performance ...>, ...]

OdeonUk::Performance.at(824, from: Date.today, to: Date.today + 2)
#=> [<OdeonUk::Performance ...>, <OdeonUk::Performance ...>, ...]

performance = OdeonUk::Performance.at(824).first
#=> <OdeonUk::Performance ...>

performance.film_name
#=> 'Street Fighter'

performance.dimension
#=> '2d'

performance.variant
#=> ['audio_described', 'imax']

performance.language
#=> 'Korean' # audio language, nil when the cinema does not tag one

performance.subtitled?
#=> true # English subtitles or open captions

performance.festival
#=> #<data Cinebase::Festival name="Cine-Excess", year=2026> # nil outside festivals

performance.starting_at
#=> 2026-10-24 08:00:00 UTC

performance.showing_on
#=> #<Date: 2026-10-24 ((2461338j,0s,0n),+0s,2299161j)>

performance.booking_url
#=> 'https://www.odeon.co.uk/ticketing/seat-picker/?showtimeId=824-69206'

performance.cinema_name
#=> 'Brighton'

performance.cinema_id
#=> '824'
```

Variants are `arts`, `audio_described`, `autism_friendly`, `baby`, `imax`,
`kids`, `senior` and `subtitled`.

## Tests

``` sh
bundle exec rake          # unit tests against fixtures
bundle exec rake live     # live API, needs curl-impersonate or ODEON_TOKEN
```

Fixtures in `test/fixtures/api` are hand-written: invented films and
addresses in the shape of Vista responses, never recorded API output.
`test/support/api_shapes.rb` describes the fields the gem reads. The unit suite
checks the fixtures against it and the live suite checks real responses, held
only in memory. When the API changes, update the shape first, then the fixtures.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Note that contributors assign all rights to the owner, Andy Croll ([github](http://github.com/andycroll)), of this gem.

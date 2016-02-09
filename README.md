# OdeonUk

A simple gem to parse the [Odeon UK website](http://odeon.co.uk) and spit out useful formatted info.

[![Gem Version](https://badge.fury.io/rb/odeon_uk.svg)](https://badge.fury.io/rb/odeon_uk)
[![Code Climate](https://codeclimate.com/github/andycroll/odeon_uk/badges/gpa.svg)](https://codeclimate.com/github/andycroll/odeon_uk)
[![Test Coverage](https://codeclimate.com/github/andycroll/odeon_uk/badges/coverage.svg)](https://codeclimate.com/github/andycroll/odeon_uk/coverage)
[![Build Status](https://travis-ci.org/andycroll/odeon_uk.svg?branch=master)](https://travis-ci.org/andycroll/odeon_uk)
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

Performance titles are sanitized as much as possible, removing 'screening type' information and 'dimension' as well as standardising all the theatre/cultural event naming (NT Live, Royal Opera House etc).

### Cinema

``` ruby
OdeonUk::Cinema.all
#=> [<OdeonUk::Cinema ...>, <OdeonUk::Cinema ...>, ...]

cinema = OdeonUk::Cinema.new(71)
#=> <OdeonUk::Cinema ...>

cinema.adr
#=> {
  street_address:   'Kingswest',
  extended_address: nil,
  locality:         'Brighton',
  region:           nil,
  postal_code:      'BN1 2RE',
  country:          'United Kingdom'
}

cinema.brand
#=> 'Odeon'

cinema.full_name
#=> 'Odeon Brighton'

cinema.id
#=> 71

cinema.postal_code
#=> 'BN1 2RE'
```

### Performances

``` ruby
OdeonUk::Performance.at(17)
#=> [<OdeonUk::Performance ...>, <OdeonUk::Performance ...>, ...]

performance = OdeonUk::Performance.at(17).first
#=> <OdeonUk::Performance ...>

performance.film_name
#=> 'Star Wars: The Force Awakens'

performance.dimension
#=> '2d'

performance.variant
#=> ['imax', 'kids']

performance.starting_at
#=> 2016-02-04 13:00:00 UTC

performance.showing_on
#=> #<Date: 2016-02-04 ((2457423j,0s,0n),+0s,2299161j)>

performance.booking_url # for now
#=> nil

performance.cinema_name
#=> 'Brighton'

performance.cinema_id
#=> 71
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Note that contributors assign all rights to the owner, Andy Croll ([github](http://github.com/andycroll)), of this gem.

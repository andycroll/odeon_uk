# OdeonUk

A simple gem to parse the [Odeon UK website](http://odeon.co.uk) and spit out useful formatted info.

[![Gem Version](https://badge.fury.io/rb/odeon_uk.png)](http://badge.fury.io/rb/odeon_uk)
[![Code Climate](https://codeclimate.com/github/andycroll/odeon_uk.png)](https://codeclimate.com/github/andycroll/odeon_uk)
[![Build Status](https://travis-ci.org/andycroll/odeon_uk.png?branch=master)](https://travis-ci.org/andycroll/odeon_uk)
[![Inline docs](http://inch-ci.org/github/andycroll/odeon_uk.png)](http://inch-ci.org/github/andycroll/odeon_uk)

## Installation

Add this line to your application's Gemfile:

    gem 'odeon_uk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install odeon_uk

## Usage

### Cinema

``` ruby
OdeonUk::Cinema.all
#=> [<OdeonUk::Cinema brand="Odeon" name="Odeon Tunbridge Wells" slug="odeon-tunbridge-wells" chain_id="23" url="...">, #=> <OdeonUk::Cinema brand="Odeon" name="Odeon Brighton" slug="odeon-brighton" chain_id="71" url="...">, ...]

OdeonUk::Cinema.find_by_id('71')
#=> <OdeonUk::Cinema brand="Odeon" name="Odeon Brighton" slug="odeon-brighton" address="..." chain_id="71" url="...">

OdeonUk::Cinema.find_by_id(71)
#=> <OdeonUk::Cinema brand="Odeon" name="Odeon Brighton" slug="odeon-brighton" address="..." chain_id="71" url="...">

cinema = OdeonUk::Cinema.find_by_slug('odeon-brighton')
#=> <OdeonUk::Cinema brand="Odeon" name="Odeon Brighton" slug="odeon-brighton" chain_id="71" url="...">

cinema.brand
#=> 'Odeon'

cinema.chain_id
#=> '71'

cinema.url
#=> "http://www.odeon.co.uk/cinemas/brighton/71/"

cinema.films
#=> [<OdeonUk::Film name="Iron Man 3">, <OdeonUk::Film name="Star Trek: Into Darkness">]

cinema.screenings
#=> [<OdeonUk::Screening film="About Time" when="2013-09-09 11:00 UTC" variant="3d">, <OdeonUk::Screening film="Iron Man 3" when="2013-09-09 13:50 UTC" variant="kids">, <OdeonUk::Screening ..>, <OdeonUk::Screening ...>]

cinema.screenings_of 'Iron Man 3'
#=> [<OdeonUk::Screening film="Iron Man 3" when="2013-09-09 11:00 UTC" variant="3d">, <OdeonUk::Screening film="Iron Man 3" when="2013-09-09 13:50 UTC" variant="kids">]

cinema.screenings_of <OdeonUk::Film name="Iron Man 3">
#=> [<OdeonUk::Screening film="Iron Man 3" when="2013-09-09 11:00 UTC" variant="3d">, <OdeonUk::Screening film="Iron Man 3" when="2013-09-09 13:50 UTC" variant="kids">]
```

### Film

``` ruby
OdeonUk::Film.all
#=> [<OdeonUk::Film name="Iron Man 3" slug="iron-man-3">, <OdeonUk::Film name="Star Trek Into Darkness" slug="star-trek-into-darkness">, <OdeonUk::Film name="Captain America: The First Avenger" slug="captain-america-the-first-avenger">, <OdeonUk::Film name="Thor: The Dark World" slug="thor-the-dark-world">]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Note that contributors assign all rights to the owner, Andy Croll ([github](http://github.com/andycroll)), of this gem.

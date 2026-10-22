# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## 5.1.0 - 2026-10-22

### Added
- `Performance#film_year`, read from a trailing `(1996)` in the title.

### Changed
- Require cinebase 5.4. Film titles lose their year suffix, `(Re-release)` and Lithuanian markers, `+ ... Q&A` and `+ Discussion` add-ons, `(35mm)`, `(70mm)` and `4K` markers; `Horror Season` and `CFF:` prefixes become festivals.

## 5.0.0 - 2026-10-22

### Changed
- Retrieve cinemas and performances from the Vista API behind odeon.co.uk instead of the retired iOS plist API.
- Cinema ids are Vista site ids, zero-padded strings such as `'017'` and `'824'` (Brighton was `71`).
- `Cinema.all` returns UK cinemas only.
- `Cinema#adr` includes the second address line. Postcodes are no longer available.
- `Cinema#url` points at the current cinema pages.
- `Performance.at` accepts inclusive `from:` and `to:` business dates, defaulting to today in London and the following 13 days. One request per day.
- Performance times come from Vista's explicit UTC offsets.
- Title sanitizer handles Met Opera and RBO season prefixes, language and encore suffixes.
- Require Ruby 3.4 or newer and cinebase 5.2, which now holds the shared Vista client, guest token retrieval, packaging task and common title rules.
- Film titles drop dub, subtitle, language, anniversary and Q&A markers, and festival prefixes.
- Convert tests from minitest spec syntax to plain `Minitest::Test` classes.

### Added
- `OdeonUk.token` for a caller-supplied guest JWT, and `OdeonUk.acquire_token!` to fetch one with `curl-impersonate`.
- Platform gems that bundle curl-impersonate 2.2.3.
- `OdeonUk::AuthenticationError` for missing, expired and rejected tokens.
- `Performance#booking_url`, `Performance#language`, `Performance#subtitled?` and `Performance#festival` (a `Cinebase::Festival` with `name` and `year`).
- `audio_described`, `autism_friendly` and `subtitled` variants.
- Live integration tests and GitHub Actions CI on Ruby 3.4 and 4.0.
- Live API shape tests that check real responses without storing them.

### Removed
- CFPropertyList dependency, Travis CI and Code Climate.
- Recorded API fixtures and the `fixtures` rake task. Fixtures are hand-written.

## 4.0.1 - 2016-02-11

### Fixed
- pass an `to_int`able `String` to methods and live success

## 4.0.0 - 2016-02-09

### Removed
- HTML parsing

### Added
- Use the `cinebase` gem to fix an common API across all gems
- Screening becomes Performance in cinebase 3.0.
- license to AGPL for free usage, MIT for commercial

## 3.0.6 - 2015-07-05

### Fixed
- Protect HTTP use against 500

## 3.0.5 - 2015-07-04

### Fixed
- API use for screenings

## 3.0.4 - 2015-05-06

### Added
- URLs created for api cinemas

## 3.0.3 - 2015-04-09

### Added
- Variants if using the API

## 3.0.2 - 2015-04-09

- fix HTML ampersands in film titles

## 3.0.1 - 2015-04-09

- fix cinema parsing over API

## 3.0.0 - 2015-03-15

- complete internal re-architecture ready for use of API
- include API source
- remove Film model (not used)

## 2.0.4 - 2015-02-18

- protect against unopened cinemas

## 2.0.3, _3rd January 2015_

- singalong sanitization

## 2.0.2, _28th September 2014_

- Default to 2d for IMAX film tech

## 2.0.1, _28th September 2014_

- you can pass strings to screening#variant

## 2.0.0, _22nd September 2014_

- add website utility class
- break up film parsing into internal classes
- Film#at builds films not cinema
- fixture update script
- title sanitizer class
- updated fixtures
- Added changelog

## 1.1.3, _8th Nov 2013_

- MIT license

## 1.1.2, _6th Nov 2013_

- version bump for fixing CI
- using UTC parsing

## 1.1.1, _6th Nov 2013_

- version bump for fixing CI

## 1.1.0, _5th Nov 2013_

First ready-for-public release

- added booking url to screenings
- screenings created with UTC Time objects not strings
- Removed 'London -' prefix from some cinema names
- added cinema addresses

## 1.0.0

- Get films and screenings out of a cinema

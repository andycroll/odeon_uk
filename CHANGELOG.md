## MASTER

### Fixed
- Protect HTTP use against 500

## 3.0.4 - 2015-05-06

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

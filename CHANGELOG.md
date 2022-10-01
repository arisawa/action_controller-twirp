# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.3.0] - 2022-10-01
### Added
- Add `#render` option `:twirp_error`
### Removed
- Delete config `handle_exceptions`

## [0.2.0] - 2022-09-29
### Added
- Error handling based on config file
- Add config generator command `rails g action_controller_twirp:install`
### Removed
- `render twirp_error: ...` syntax

## [0.1.1] - 2022-09-21
### Fixed
- Set response header returned from twirp rack app

## [0.1.0] - 2022-09-21
### Added
- First release

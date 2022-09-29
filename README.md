# ActionController::Twirp

[![build](https://github.com/arisawa/action_controller-twirp/actions/workflows/ruby.yml/badge.svg)](https://github.com/arisawa/action_controller-twirp/actions/workflows/ruby.yml)
![License](https://img.shields.io/github/license/arisawa/action_controller-twirp)

Implement twirp service with Rails controller.

## Installation
Add this line to your application's Gemfile:

```ruby
gem "action_controller-twirp"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install action_controller-twirp
```

## Usage
[twirp-ruby](https://github.com/twitchtv/twirp-ruby) with Ruby on Rails.

It provides routing method `twirp` that maps twirp service class and Rails controller class, and a module of `ActionController::Twirp` to help execute RPC methods and rendering Twirp::Error.

First, you should generate twirp service class. see: [example in twirp-ruby](https://github.com/twitchtv/twirp-ruby/wiki#usage-example)

Next, add twirp action in config/routes.rb
```ruby
Rails.application.routes.draw do
  scope :twirp do
    twirp Example::V1::UserApiService, controller: 'users'
  end
end
```

Result of `bin/rails routes`
```sh
> bin/rails routes
 Prefix  Verb  URI Pattern                                    Controller#Action
         POST  /twirp/example.v1.UserApi/ListUsers(.:format)  users#list_users
         POST  /twirp/example.v1.UserApi/GetUser(.:format)    users#get_user
```

Finally, implement rpc method your controller
```ruby
class UsersController < ApplicationController # :nodoc:
  include ActionController::Twirp

  USERS = [
    { id: 1, name: 'Anna' },
    { id: 2, name: 'Reina' }
  ].freeze

  def list_users(_req, _env)
    Example::V1::ListUsersResponse.new(users: USERS)
  end

  def get_user(req, _env)
    user = USERS.find { |u| u[:id] == req.id }

    raise ActiveRecord::RecordNotFound unless user

    Example::V1::User.new(user)
  end
end
```

### Error handling

twirp-ruby eventually provides us with a rack app, which handles the exception and returns a response when an exception occurs.
Provide settings for exception handling, as the status code or body may be unexpected when an error occurs.

You can install initializer by rails generate command
```sh
> bin/rails generate action_controller:twirp:install

> cat config/initializers/action_controller_twirp.rb
# frozen_string_literal: true

ActionController::Twirp::Config.setup do |config|
  # Handle exceptions
  #   true: handling by ActionController::Twirp
  #   false: handling by Twirp::Service (default)
  # config.handle_exceptions = false

  # ---
  # The following configurations ignore when handle_exceptions is false
  # ---

  # Mapping your exception classes and Twirp::Error::ERROR_CODES
  # String => Symbol
  # config.exception_codes = {
  #   'ActiveRecord::RecordInvalid' => :invalid_argument,
  #   'ActiveRecord::RecordNotFound' => :not_found,
  #   'My::Exception' => :aborted,
  # }

  # Block to make Twirp::Error message when exception_codes exist
  # config.build_message = ->(exception) {}

  # Block to make Twirp::Error metadata. when exception_codes exist
  # It MUST return Hash value
  # config.build_metadata = ->(exception) {}

  # Block to run additional process. e.g. logging
  # config.on_exceptions = ->(exception) {}
end
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

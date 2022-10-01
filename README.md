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

Next, install initializer.
```sh
bin/rails g action_controller:twirp:install
```

Next, add twirp action in config/routes.rb.
```ruby
Rails.application.routes.draw do
  scope :twirp do
    twirp Example::V1::UserApiService, controller: 'users'
  end
end
```

Result of `bin/rails routes`.
```sh
> bin/rails routes
 Prefix  Verb  URI Pattern                                    Controller#Action
         POST  /twirp/example.v1.UserApi/ListUsers(.:format)  users#list_users
         POST  /twirp/example.v1.UserApi/GetUser(.:format)    users#get_user
```

Finally, implement rpc method your controller.
```ruby
class UsersController < ApplicationController
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

We must follow protocol when using Twirp. Specifically,

- It accepts request parameters specified in proto file, and must return response body.
- If an exception occurs, a response body of Twirp::Error's JSON must be returned.

This section describes when an exception occurs.

The following blocks are in the order of method calls when requested to the Rails app. (It's quite simplified)
```
 :
ActionController::Metal#dispatch
  AbstractController::Base#process
     :
    ActionController::Rescue#process_action
    ActionController::Callbacks#process_action
     :
    (Some module's #process_action is called)
     :
    AbstractController::Base#process_action
      AbstractController::Base#send_action
```

The gem is only override `#send_action`. It follows twirp protocal in this one.

For example, if an exception occurs in the callback, Rails app will return a response, so we must be implemented so that the twirp protocol can be followed.

This is easy to do, see below.

First, modify `exception_codes` config.
```sh
> cat config/initializers/action_controller_twirp.rb
# frozen_string_literal: true

ActionController::Twirp::Config.setup do |config|
  # Mapping your exception classes and Twirp::Error::ERROR_CODES
  # String => Symbol
  config.exception_codes = {
    'ActiveRecord::RecordInvalid' => :invalid_argument,
    'ActiveRecord::RecordNotFound' => :not_found,
    'MyApp::Unauthenticated' => :unauthenticated,
  }

  # Block to make Twirp::Error message when exception_codes exist
  # config.build_message = ->(exception) {}

  # Block to make Twirp::Error metadata. when exception_codes exist
  # It MUST return Hash value
  # config.build_metadata = ->(exception) {}

  # Block to run additional process. e.g. logging
  # config.on_exceptions = ->(exception) {}
end
```

Next, write a `rescue_from` block as usual and use the `:twirp_error` key on `#render`
```ruby
class UsersController < ApplicationController
  include ActionController::Twirp

  before_action :authenticate!

  rescue_from MyApp::Unauthenticated do |e|
    render twirp_error: e
  end

  :
  :

  private

  def authenticate!
    return if your_logic

    raise MyApp::Unauthenticated
  end
end
```

See [dummy app controller](test/dummy/app/controllers/users_controller.rb) and [integration test](test/integration/users_test.rb) for details.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

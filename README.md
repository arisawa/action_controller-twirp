# ActionController::Twirp

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

  rescue_from ActiveRecord::RecordNotFound do |e|
    twerr = Twirp::Error.not_found('The message',
                                   reason: e.class.name.demodulize,
                                   id: params[:id].to_s)
    render twirp_error: twerr
  end

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

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

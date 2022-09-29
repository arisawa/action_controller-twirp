# frozen_string_literal: true

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

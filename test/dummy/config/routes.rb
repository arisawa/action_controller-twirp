# frozen_string_literal: true

Rails.application.routes.draw do
  scope :twirp do
    twirp Example::V1::UserApiService, controller: 'users'
  end
end

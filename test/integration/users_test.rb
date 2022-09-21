# frozen_string_literal: true

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  test '#list_users' do
    post '/twirp/example.v1.UserApi/ListUsers', params: {}, as: :json

    assert_equal(200, status)
    assert_equal({ users: [{ id: '1', name: 'Anna' }, { id: '2', name: 'Reina' }] }.to_json, body)
  end

  test '#get_user is given existing id' do
    post '/twirp/example.v1.UserApi/GetUser', params: { id: 1 }, as: :json

    assert_equal(200, status)
    assert_equal({ id: '1', name: 'Anna' }.to_json, body)
  end

  test '#get_user is given unknown id and handle_exceptions is false' do
    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(404, status)
    assert_equal(
      {
        code: 'not_found',
        msg: 'The message',
        meta: { reason: 'RecordNotFound', id: '100' }
      }.to_json,
      body
    )
  end
end

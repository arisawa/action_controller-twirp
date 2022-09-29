# frozen_string_literal: true

require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest
  include ConfigHelper

  test '#list_users' do
    post '/twirp/example.v1.UserApi/ListUsers', params: {}, as: :json

    assert_equal(200, status)
    assert_equal({ users: [{ id: '1', name: 'Anna' }, { id: '2', name: 'Reina' }] }.to_json, body)
    assert_equal('application/json', response.header['Content-Type'])
  end

  test '#get_user is given existing id' do
    post '/twirp/example.v1.UserApi/GetUser', params: { id: 1 }, as: :json

    assert_equal(200, status)
    assert_equal({ id: '1', name: 'Anna' }.to_json, body)
    assert_equal('application/json', response.header['Content-Type'])
  end

  test '#get_user is given unknown id and handle_exceptions is false' do
    config.setup do |c|
      c.handle_exceptions = false
    end

    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(500, status)
    assert_equal(
      {
        code: 'internal',
        msg: 'ActiveRecord::RecordNotFound',
        meta: { cause: 'ActiveRecord::RecordNotFound' }
      }.to_json,
      body
    )
    assert_equal('application/json', response.header['Content-Type'])
  end

  test '#get_user is given unknown id and handle_exceptions is true' do
    config.setup do |c|
      c.handle_exceptions = true
    end

    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(500, status)
    assert_equal(
      {
        code: 'internal',
        msg: 'ActiveRecord::RecordNotFound',
        meta: { cause: 'ActiveRecord::RecordNotFound' }
      }.to_json,
      body
    )
    assert_equal('application/json', response.header['Content-Type'])
  end

  test '#get_user is given unknown id and exception_codes is configured' do
    config.setup do |c|
      c.handle_exceptions = true
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
    end

    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(404, status)
    assert_equal({ code: 'not_found', msg: '' }.to_json, body)
    assert_equal('application/json', response.header['Content-Type'])
  end

  test '#get_user is given unknown id and build_message is configured' do
    config.setup do |c|
      c.handle_exceptions = true
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
      config.build_message = ->(e) { e.class.name.demodulize }
    end

    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(404, status)
    assert_equal({ code: 'not_found', msg: 'RecordNotFound' }.to_json, body)
    assert_equal('application/json', response.header['Content-Type'])
  end

  test '#get_user is given unknown id and build_metadata is configured' do
    config.setup do |c|
      c.handle_exceptions = true
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
      c.build_metadata = ->(e) { { reason: e.class.name.demodulize } }
    end

    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(404, status)
    assert_equal({ code: 'not_found', msg: '', meta: { reason: 'RecordNotFound' } }.to_json, body)
  end

  test '#get_user is given unknown id and on_exceptions is configured' do
    config.setup do |c|
      c.handle_exceptions = true
      c.on_exceptions = ->(e) { Rails.logger.error(e.class.name.demodulize) }
    end

    logger = Minitest::Mock.new
    logger.expect :info, true
    logger.expect :error, true, ['RecordNotFound']

    Rails.stub :logger, logger do
      post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json
    end

    assert_mock logger
  end

  test '#get_user is given unknown id and on_exceptions is configured but raises StandardError' do
    config.setup do |c|
      c.handle_exceptions = true
      c.build_metadata = ->(e) { { reason: e.class.name.demodulize } }
      c.on_exceptions = ->(_) { raise StandardError }
    end

    post '/twirp/example.v1.UserApi/GetUser', params: { id: 100 }, as: :json

    assert_equal(500, status)
    assert_equal({ code: 'internal', msg: 'StandardError', meta: { cause: 'StandardError' } }.to_json, body)
  end
end

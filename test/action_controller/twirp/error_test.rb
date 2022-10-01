# frozen_string_literal: true

require 'test_helper'

class ErrorTest < ActiveSupport::TestCase
  include ConfigHelper

  exception = ActiveRecord::RecordNotFound.new

  test 'exception_codes is not configured' do
    config.setup do |c|
      c.exception_codes = {}
    end

    twerr = ActionController::Twirp::Error.new(exception).generate

    assert_equal(
      {
        code: :internal,
        msg: 'ActiveRecord::RecordNotFound',
        meta: { cause: 'ActiveRecord::RecordNotFound' }
      },
      twerr.to_h
    )
  end

  test 'exception_codes is configured' do
    config.setup do |c|
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
    end

    twerr = ActionController::Twirp::Error.new(exception).generate

    assert_equal(
      {
        code: :not_found,
        msg: ''
      },
      twerr.to_h
    )
  end

  test 'exception_codes and build_message are configured' do
    config.setup do |c|
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
      c.build_message = ->(e) { e.class.name.demodulize }
    end

    twerr = ActionController::Twirp::Error.new(exception).generate

    assert_equal(
      {
        code: :not_found,
        msg: 'RecordNotFound'
      },
      twerr.to_h
    )
  end

  test 'exception_codes and build_metadata are configured' do
    config.setup do |c|
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
      c.build_metadata = ->(e) { { reason: e.class.name.demodulize } }
    end

    twerr = ActionController::Twirp::Error.new(exception).generate

    assert_equal(
      {
        code: :not_found,
        msg: '',
        meta: { reason: 'RecordNotFound' }
      },
      twerr.to_h
    )
  end

  test 'exception_codes and build_metadata are configured but it raises StandardError' do
    config.setup do |c|
      c.exception_codes = {
        'ActiveRecord::RecordNotFound' => :not_found
      }
      c.build_metadata = ->(_) { raise StandardError }
    end

    twerr = ActionController::Twirp::Error.new(exception).generate

    assert_equal(
      {
        code: :internal,
        msg: 'StandardError',
        meta: { cause: 'StandardError' }
      },
      twerr.to_h
    )
  end
end

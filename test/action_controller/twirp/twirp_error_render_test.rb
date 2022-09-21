# frozen_string_literal: true

require 'test_helper'

class TwirpErrorRendererTest < ActiveSupport::TestCase
  test 'options is empty' do
    content = ::Twirp::Error.new(:not_found, 'Not Found', reason: 'id:1 is not found')
    options = {}
    result = ActionController::Twirp::TwirpErrorRenderer.new(content, options).to_render_option

    assert_equal(
      {
        json: { code: :not_found, msg: 'Not Found', meta: { reason: 'id:1 is not found' } },
        status: 404,
        content_type: 'application/json'
      },
      result
    )
  end

  test 'options are given' do
    content = ::Twirp::Error.new(:not_found, 'Not Found', reason: 'id:1 is not found')
    options = { status: :ok, content_type: 'plain/text', the: :ninja }
    result = ActionController::Twirp::TwirpErrorRenderer.new(content, options).to_render_option

    assert_equal(
      {
        json: { code: :not_found, msg: 'Not Found', meta: { reason: 'id:1 is not found' } },
        status: 404,
        content_type: 'application/json',
        the: :ninja
      },
      result
    )
  end

  test 'unknown code is specified' do
    content = ::Twirp::Error.new(:the_ninja, 'Not Found', reason: 'id:1 is not found')
    options = {}
    result = ActionController::Twirp::TwirpErrorRenderer.new(content, options).to_render_option

    assert_equal(
      {
        json: { code: :internal, msg: 'Invalid code: the_ninja', meta: { invalid_code: 'the_ninja' } },
        status: 500,
        content_type: 'application/json'
      },
      result
    )
  end

  test 'Hash is given for content' do
    content = { code: :the_ninja, msg: 'Not Found', meta: { reason: 'id:1 is not found' } }
    options = {}

    assert_raises(ArgumentError, 'Only Twirp::Error instance can be specified') do
      ActionController::Twirp::TwirpErrorRenderer.new(content, options).to_render_option
    end
  end
end

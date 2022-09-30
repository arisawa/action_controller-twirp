# frozen_string_literal: true

require 'test_helper'

class ErrorRendererTest < ActiveSupport::TestCase
  test 'options is empty' do
    content = StandardError.new
    options = {}
    result = ActionController::Twirp::ErrorRenderer.new(content, options).to_render_option

    assert_equal(
      {
        json: { code: :internal, msg: 'StandardError', meta: { cause: 'StandardError' } },
        status: 500,
        content_type: 'application/json'
      },
      result
    )
  end

  test 'options are given' do
    content = StandardError.new
    options = { status: :ok, content_type: 'plain/text', the: :ninja }
    result = ActionController::Twirp::ErrorRenderer.new(content, options).to_render_option

    assert_equal(
      {
        json: { code: :internal, msg: 'StandardError', meta: { cause: 'StandardError' } },
        status: 500,
        content_type: 'application/json',
        the: :ninja
      },
      result
    )
  end
end

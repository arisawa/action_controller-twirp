# frozen_string_literal: true

require 'test_helper'

module ActionController
  class TwirpTest < ActiveSupport::TestCase
    test 'it has a version number' do
      assert ActionController::Twirp::VERSION
    end
  end
end

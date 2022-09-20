# frozen_string_literal: true

require 'test_helper'

module ActionDispatch
  module Routing
    class MapperTest < ActiveSupport::TestCase
      Mapper.prepend(Mapper::Twirp)

      class FakeSet < ActionDispatch::Routing::RouteSet
        def defaults
          routes.map(&:defaults)
        end
      end

      def test_twirp
        fakeset = FakeSet.new
        mapper = Mapper.new fakeset
        mapper.twirp Example::V1::UserApiService, controller: 'users'
        assert_equal({ controller: 'users', action: 'list_users' }, fakeset.defaults[0])
        assert_equal({ controller: 'users', action: 'get_user' }, fakeset.defaults[1])
      end
    end
  end
end

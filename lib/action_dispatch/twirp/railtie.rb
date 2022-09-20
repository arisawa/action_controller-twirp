# frozen_string_literal: true

require 'action_dispatch/routing/mapper/twirp'

module ActionDispatch
  module Twirp
    class Railtie < ::Rails::Railtie # :nodoc:
      initializer 'action_dispatch.twirp' do
        ActionDispatch::Routing::Mapper.prepend(ActionDispatch::Routing::Mapper::Twirp)
      end
    end
  end
end

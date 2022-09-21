# frozen_string_literal: true

require 'action_controller/twirp/twirp_error_renderer'
require 'action_dispatch/twirp/railtie'

module ActionController
  module Twirp
    class Railtie < ::Rails::Railtie # :nodoc:
      initializer 'action_controller.twirp' do
        ActiveSupport.on_load(:action_controller) do
          ActionController::Renderers.add :twirp_error do |content, options|
            renderer = TwirpErrorRenderer.new(content, options)
            render(**renderer.to_render_option)
          end
        end
      end
    end
  end
end

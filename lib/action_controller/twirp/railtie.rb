# frozen_string_literal: true

require 'action_controller/twirp/twirp_error_renderer'
require 'action_dispatch/twirp/railtie'

module ActionController
  module Twirp
    class Railtie < ::Rails::Railtie
    end
  end
end

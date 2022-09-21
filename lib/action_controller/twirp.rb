# frozen_string_literal: true

require 'action_controller/twirp/version'
require 'action_controller/twirp/railtie'

module ActionController
  # Module to execute your implemented methods on Twirp with Rails
  module Twirp
    private

    # Override it to call a twirp class from request path
    def send_action(*_args)
      twirp_service_class.raise_exceptions = true

      status, header, body = twirp_service_class.new(self)&.call(request.env)

      response.status = status
      response.header.merge(header)
      response.body = body
    end

    def twirp_service_class
      return @twirp_service_class if defined? @twirp_service_class

      class_name = request.path.split('/')[-2].underscore.gsub('.', '/').classify
      @twirp_service_class = "#{class_name}Service".constantize
    end
  end
end

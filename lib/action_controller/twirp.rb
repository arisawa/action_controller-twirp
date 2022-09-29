# frozen_string_literal: true

require 'action_controller/twirp/version'
require 'action_controller/twirp/railtie'
require 'action_controller/twirp/config'

module ActionController
  # Module to execute your implemented methods on Twirp with Rails
  module Twirp
    private

    # Override it to call a twirp class from request path
    def send_action(*_args)
      twirp_service_class.raise_exceptions = Config.handle_exceptions

      status, header, body = twirp_action

      response.status = status
      response.header.merge!(header)
      response.body = body
    end

    def twirp_service_class
      return @twirp_service_class if defined? @twirp_service_class

      class_name = request.path.split('/')[-2].underscore.gsub('.', '/').classify
      @twirp_service_class = "#{class_name}Service".constantize
    end

    def twirp_action
      twirp_service_class.new(self)&.call(request.env)
    rescue StandardError => e
      begin
        Config.on_exceptions.call(e)
      rescue StandardError => hook_e
        e = hook_e
      end
      twirp_error_response(e)
    end

    def twirp_error_response(exception)
      twerr = twirp_error(exception)
      twirp_service_class.error_response(twerr)
    end

    def twirp_error(exception)
      if Config.exception_codes.key?(exception.class.to_s)
        code = Config.exception_codes[exception.class.to_s]
        message = Config.build_message.call(exception)
        metadata = Config.build_metadata.call(exception)

        ::Twirp::Error.public_send(code, message, metadata)
      else
        ::Twirp::Error.internal_with(exception)
      end
    rescue StandardError => e
      ::Twirp::Error.internal_with(e)
    end
  end
end

# frozen_string_literal: true

require 'action_controller/twirp/config'

module ActionController
  module Twirp
    # Class to generate Twirp::Error from an exception class and Config
    class Error
      # @param content [Exception] given as a value of :twirp_error key of render method.
      def initialize(exception)
        unless exception.is_a?(Exception)
          raise ArgumentError, 'Instance of Exception class can be specified'
        end

        @exception = exception
      end

      def generate
        if Config.exception_codes.key?(exception_name)
          code = Config.exception_codes[exception_name]
          message = Config.build_message.call(exception)
          metadata = Config.build_metadata.call(exception)

          ::Twirp::Error.public_send(code, message, metadata)
        else
          ::Twirp::Error.internal_with(exception)
        end
      rescue StandardError => e
        ::Twirp::Error.internal_with(e)
      end

      private

      attr_reader :exception

      def exception_name
        exception.class.to_s
      end
    end
  end
end

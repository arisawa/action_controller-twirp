# frozen_string_literal: true

module ActionController
  module Twirp
    # Convert Twirp::Error to #render option
    class TwirpErrorRenderer
      # @param content [Twirp::Error] given as a value of :twirp_error key of render method.
      # @param options [Hash] options of render method.
      def initialize(content, options)
        unless content.is_a?(::Twirp::Error)
          raise ArgumentError, 'Only Twirp::Error instance can be specified'
        end

        @content = content
        @options = options.dup
      end

      def to_render_option
        {
          json: twirp_error.to_h,
          **@options.merge(status: status, content_type: content_type)
        }
      end

      private

      def twirp_error
        return @twirp_error if defined? @twirp_error

        code = @content.code

        @twirp_error = if ::Twirp::Error.valid_code?(code)
                         @content
                       else
                         ::Twirp::Error.internal("Invalid code: #{code}", invalid_code: code.to_s)
                       end
      end

      def status
        ::Twirp::ERROR_CODES_TO_HTTP_STATUS[twirp_error.code]
      end

      def content_type
        ::Twirp::Encoding::JSON
      end
    end
  end
end

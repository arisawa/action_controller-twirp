# frozen_string_literal: true

module ActionController
  module Twirp
    # Convert Twirp::Error to #render option
    class ErrorRenderer
      # @param content [Exception] given as a value of :twirp_error key of render method.
      # @param options [Hash] options of render method.
      def initialize(content, options)
        unless content.is_a?(Exception)
          raise ArgumentError, 'Instance of Exception class can be specified'
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

      attr_reader :content, :options

      def twirp_error
        @twirp_error ||= Error.new(content).generate
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

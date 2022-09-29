# frozen_string_literal: true

require 'active_support/core_ext/module/attribute_accessors'

module ActionController
  module Twirp
    # Configration for ActionController::Twirp
    module Config
      # Handle exceptions
      #   true: handling by ActionController::Twirp
      #   false: handling by Twirp::Service
      mattr_accessor :handle_exceptions, default: false

      # ---
      # The following configurations ignore when handle_exceptions is false
      # ---

      # Mapping your exception classes and Twirp::Error::ERROR_CODES
      mattr_accessor :exception_codes, default: {}

      # Block to make Twirp::Error message
      mattr_accessor :build_message, default: ->(exception) {}

      # Block to make Twirp::Error metadata
      mattr_accessor :build_metadata, default: ->(exception) {}

      # Block to run additional process. e.g. logging
      mattr_accessor :on_exceptions, default: ->(exception) {}

      def self.setup
        yield self
      end
    end
  end
end

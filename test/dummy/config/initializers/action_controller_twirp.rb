# frozen_string_literal: true

ActionController::Twirp::Config.setup do |config|
  # Mapping your exception classes and Twirp::Error::ERROR_CODES
  # String => Symbol
  config.exception_codes = {
    'ActiveRecord::RecordInvalid' => :invalid_argument,
    'ActiveRecord::RecordNotFound' => :not_found,
    'My::Exception' => :aborted,
    'UnauthenticatedError' => :unauthenticated
  }

  # Block to make Twirp::Error message when exception_codes exist
  # config.build_message = ->(exception) {}

  # Block to make Twirp::Error metadata. when exception_codes exist
  # It MUST return Hash value
  # config.build_metadata = ->(exception) {}

  # Block to run additional process. e.g. logging
  # config.on_exceptions = ->(exception) {}
end

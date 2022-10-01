# frozen_string_literal: true

module ConfigHelper # :nodoc:
  def config
    ActionController::Twirp::Config
  end

  def setup
    @config = config.class_variables.to_h { |v| [v, config.class_variable_get(v)] }.to_h
  end

  def teardown
    @config.each { |k, v| config.class_variable_set(k, v) } # rubocop:disable Style/ClassVars
  end
end

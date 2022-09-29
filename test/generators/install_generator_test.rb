# frozen_string_literal: true

require 'test_helper'

class InstallGeneratorTest < Rails::Generators::TestCase
  tests ActionController::Twirp::Generators::InstallGenerator
  destination File.expand_path('../../tmp', __dir__)
  setup :prepare_destination

  test 'assert all files are properly created' do
    run_generator
    assert_file 'config/initializers/action_controller_twirp.rb'
  end
end

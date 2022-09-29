# frozen_string_literal: true

module ActionController
  module Twirp
    module Generators
      class InstallGenerator < Rails::Generators::Base # :nodoc:
        source_root File.expand_path('../../templates', __dir__)

        desc 'Creates a ActionController::Twirp initializer'
        def copy_initializer
          template 'action_controller_twirp.rb', 'config/initializers/action_controller_twirp.rb'
        end
      end
    end
  end
end

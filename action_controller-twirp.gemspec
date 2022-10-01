# frozen_string_literal: true

require_relative 'lib/action_controller/twirp/version'

Gem::Specification.new do |spec|
  spec.name        = 'action_controller-twirp'
  spec.version     = ActionController::Twirp::VERSION
  spec.authors     = ['Kosuke Arisawa']
  spec.email       = ['arisawa@gmail.com']
  spec.homepage    = 'https://github.com/arisawa/action_controller-twirp'
  spec.summary     = 'Twirp for Rails Controller'
  spec.description = 'You can implement twirp service with Rails controller'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 5.0.0'
  spec.add_dependency 'twirp', '~> 1.9'

  spec.add_development_dependency 'rubocop', '~> 1.36.0'
end

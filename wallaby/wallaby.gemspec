# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'wallaby/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = 'wallaby'
  spec.version       = Wallaby::VERSION
  spec.authors       = ['Tianwen Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       =
    'Autocomplete the resourceful actions and views for ORMs for admin interface and other purposespec.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wallaby-rails/wallaby-rails/blob/main/wallaby'

  spec.metadata = {
    'rubygems_mfa_required' => 'true',
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/CHANGELOG.md"
  }

  spec.files = Dir[
    '{app,config,db,lib,vendor}/**/*',
    'LICENSE',
    'README.rdoc'
  ]

  spec.add_dependency 'wallaby-core'

  # This will determine wallaby-core's version
  spec.add_dependency 'wallaby-active_record', '~> 0.3.0'

  # assets gems
  spec.add_dependency 'jbuilder'
  spec.add_dependency 'sass-rails'
  spec.add_dependency 'sprockets-rails'

  spec.add_development_dependency 'foreman'
  spec.add_development_dependency 'wallaby-cop'
end

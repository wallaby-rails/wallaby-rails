# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'wallaby/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'wallaby-active_record'
  spec.version       = Wallaby::ActiveRecordGem::VERSION
  spec.authors       = ['Tianwen Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       = "Wallaby's ActiveRecord ORM adapter"
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wallaby-rails/wallaby-rails/blob/main/wallaby-active_record'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/CHANGELOG.md",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir[
    'lib/**/*',
    'LICENSE',
    'README.md'
  ]

  # @see the dependency definition for railties in wallaby-core
  spec.add_dependency 'activerecord'
  spec.add_dependency 'wallaby-core', '~> 0.3.1'

  spec.add_development_dependency 'cancancan'
  spec.add_development_dependency 'pundit'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'wallaby-cop'
end

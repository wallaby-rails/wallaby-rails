# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'wallaby/view/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = 'wallaby-view'
  spec.version       = Wallaby::View::VERSION
  spec.authors       = ['Tianwen Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       = 'Wallaby View to extend Rails layout/template/partial inheritance chain.'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wallaby-rails/wallaby-rails/blob/main/wallaby-view'

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
  spec.require_paths = ['lib']

  spec.add_dependency 'railties', '>= 4.2.0'

  spec.add_development_dependency 'github-markup'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'wallaby-cop'
  spec.add_development_dependency 'yard'
end

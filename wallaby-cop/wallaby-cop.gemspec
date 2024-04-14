# frozen_string_literal: true

app_name = 'wallaby-cop'
require "#{__dir__}/lib/#{app_name}"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name          = app_name
  spec.version       = Wallaby::Cop::VERSION
  spec.authors       = ['Tianwen Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       = 'Rubocop configuration for Wallaby projects'
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/wallaby-rails/wallaby-rails/blob/main/#{app_name}"

  spec.files = Dir['rubocop.yml', 'lib/wallaby-cop.rb']

  spec.add_dependency 'gitlab-styles'
  spec.add_dependency 'rubocop-rails'
  spec.add_dependency 'rubocop-rspec'
end

# frozen_string_literal: true

app_name = 'wallaby-cop'
require "#{__dir__}/lib/#{app_name}"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = app_name
  s.version = Wallaby::Cop::VERSION
  s.authors = ['Tianwen Chen']
  s.email = ['me@tian.im']
  s.homepage = "https://github.com/wallaby-rails/#{app_name}"
  s.summary = s.description = 'Rubocop configuration for Wallaby projects'
  s.license = 'MIT'

  s.files = Dir['rubocop.yml', 'lib/wallaby-cop.rb']

  s.add_dependency 'gitlab-styles'
  s.add_dependency 'rubocop-rails'
  s.add_dependency 'rubocop-rspec'
end

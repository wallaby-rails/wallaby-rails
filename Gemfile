# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.4.1'

gem 'rails', '~> 8.0.0'

gem 'wallaby', path: './wallaby'
gem 'wallaby-core', path: './wallaby-core'
gem 'wallaby-active_record', path: './wallaby-active_record'
gem 'wallaby-view', path: './wallaby-view'
gem 'wallaby-cop', path: './wallaby-cop'

gem 'puma'
gem 'cancancan'
gem 'devise'
gem 'mysql2'
gem 'pg'
gem 'pundit'
gem 'sqlite3'

gem 'simple_blog_theme', git: 'https://github.com/tian-im/simple_blog_theme.git', branch: 'main' # rubocop:disable Cop/GemFetcher

group :development, :test do
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'ffaker'
  gem 'pry-rails'
  gem 'yard'
end

group :development do
  gem 'better_errors'
  gem 'massa'
  gem 'memory_profiler'
  # gems/massa-0.6.0/lib/massa/analyzer.rb:4: warning: ostruct was loaded from the standard library, but will no longer be part of the default gems starting from Ruby 3.5.0.
  gem 'ostruct'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'turbolinks'
end

# @see https://github.com/sass/sassc-ruby/issues/146
# TODO: remove this line when it's resolved
# gem 'sassc', '< 2.2.0'
gem 'sassc'

group :test do
  gem 'database_cleaner'
  gem 'deep-cover'
  gem 'generator_spec'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'webmock'
end

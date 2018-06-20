source 'https://rubygems.org'

# Declare your gem's dependencies in wallaby.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]
# gem 'rails', git: 'https://github.com/rails/rails', branch: 'master'
gem 'cancancan'
gem 'her'
gem 'pundit'
gem 'rails', '~>5.2'

group :development, :test do
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'devise'
  gem 'ffaker'
  gem 'mysql2'
  gem 'pg'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'yard'
end

group :development do
  gem 'better_errors'
  gem 'massa'
  gem 'memory_profiler'
  gem 'turbolinks'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'simplecov'
  gem 'webmock'
end

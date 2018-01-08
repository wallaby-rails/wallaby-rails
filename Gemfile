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
gem 'rails', '~> 5.1.4'

group :development, :test do
  gem 'binding_of_caller'
  gem 'byebug'
  gem 'devise'
  gem 'ffaker'
  gem 'haml_lint'
  gem 'i18n-tasks'
  # gem 'inch'
  gem 'mysql2'
  gem 'pg'
  gem 'pry-rails'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'sqlite3'
end

group :development do
  gem 'better_errors'
  gem 'brakeman'
  gem 'massa'
  gem 'memory_profiler'
  gem 'rails_best_practices'
  gem 'simplecov'
  gem 'turbolinks'
end

group :test do
  gem 'database_cleaner'
  gem 'rails-controller-testing'
end

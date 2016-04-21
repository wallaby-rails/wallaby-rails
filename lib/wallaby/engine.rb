# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines even they don't appear in the `Gemfile`
require 'devise'
require 'cancancan'
require 'kaminari'
require 'redcarpet'

require 'sass-rails'
require 'bootstrap-sass'
require 'bootstrap3-datetimepicker-rails'
require 'codemirror-rails'
require 'jquery-minicolors-rails'
require 'jquery-rails'
require 'momentjs-rails'
require 'rails-bootstrap-markdown'
require 'summernote-rails'

module Wallaby
  class Engine < ::Rails::Engine
    # isolate_namespace Wallaby
    initializer 'wallaby.deflate' do |app|
      app.config.middleware.use Rack::Deflater
    end

    initializer 'wallaby.initialize_cache' do |app|
      Rails.cache.delete_matched %r(\Awallaby/)
    end

    initializer 'wallaby.assets.precompile' do |app|
      app.config.assets.precompile += %w( wallaby/form.js wallaby/form.css )
      app.config.assets.precompile += %w( codemirror* codemirror/**/* )
    end
  end
end

require 'wallaby/configuration'

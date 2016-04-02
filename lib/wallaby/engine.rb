# NOTE: We need to require the following rails engines
# so that the main app could pick up the assets from these engines even they don't appear in the `Gemfile`
require 'devise'
require 'cancancan'
require 'kaminari'
require 'redcarpet'

require 'sass-rails'
require 'jquery-rails'
require 'bootstrap-sass'
require 'momentjs-rails'
require 'bootstrap3-datetimepicker-rails'
require 'rails-bootstrap-markdown'
require 'summernote-rails'
require 'codemirror-rails'

module Wallaby
  class Engine < ::Rails::Engine
    # isolate_namespace Wallaby
    initializer "wallaby.assets.precompile" do |app|
      app.config.assets.precompile += %w( wallaby/form.js wallaby/form.css )
      app.config.assets.precompile += %w( codemirror* codemirror/**/* )
    end
  end
end

require 'wallaby/configuration'

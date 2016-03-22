require 'devise'
require 'kaminari' # required before requiring rails

module Wallaby
  class Engine < ::Rails::Engine
    # isolate_namespace Wallaby
    initializer "wallaby.assets.precompile" do |app|
      app.config.assets.precompile += %w( wallaby/form.js wallaby/form.css )
      app.config.assets.precompile += %w( codemirror* codemirror/**/* )
    end

    {
      'jquery-rails' => nil,
      'bootstrap-sass' => '/assets/*',
      'momentjs-rails' => nil,
      'bootstrap3-datetimepicker-rails' => nil,
      'rails-bootstrap-markdown' => '/app/assets/*',
      'summernote-rails' => nil,
      'codemirror-rails' => nil
    }.each do |gem_name, assets_folders|
      initializer "#{ gem_name }.assets.precompile" do |app|
        require gem_name

        app.config.assets.paths += Dir[ "#{ Gem.loaded_specs[ gem_name ].full_gem_path }#{ assets_folders || '/vendor/assets/*' }" ]
      end
    end
  end
end

require 'wallaby/configuration'

module Wallaby
  # @private
  class Engine < ::Rails::Engine
    initializer 'wallaby.assets.precompile' do |_|
      config.assets.precompile +=
        %w(
          codemirror* codemirror/**/*
          wallaby/404.png wallaby/422.png wallaby/500.png
          turbolinks
        )
    end

    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see http://rmosolgo.github.io/blog/2017/04/12/watching-files-during-rails-development/
      config.to_prepare do
        if Rails.env.development? || Rails.configuration.eager_load
          Rails.logger.debug '  [WALLABY] Reloading...'
          ::Wallaby::Map.clear
          ::Wallaby::Utils.preload_all
        end
      end
    end

    config.before_eager_load do
      # We need to ensure that the core models are loaded before anything else
      Rails.logger.debug '  [WALLABY] Preload all model files.'
      ::Wallaby::Utils.preload 'app/models/**/*.rb'
    end

    config.after_initialize do
      # Preload the rest files
      unless Rails.env.development? || Rails.configuration.eager_load
        Rails.logger.debug '  [WALLABY] Preload files after initialize.'
        ::Wallaby::Utils.preload_all
      end
    end
  end
end

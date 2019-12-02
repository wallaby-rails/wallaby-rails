module Wallaby
  # UI engine
  class UiEngine < ::Rails::Engine
    initializer 'wallaby.autoload_paths', before: :set_load_path do |_|
      # NOTE: this needs to be run before `set_load_path`
      # so that files under `app/views` can be eager loaded
      # and therefore, Wallaby's renderer can function properly
      [config].each do |conf|
        next if conf.paths['app/views'].eager_load?

        conf.paths.add 'app/views', eager_load: true
      end
    end

    initializer 'wallaby.assets.precompile' do |_|
      config.assets.precompile +=
        %w(
          wallaby/application.js
          wallaby/application.css
          wallaby/bad_request.png
          wallaby/forbidden.png
          wallaby/internal_server_error.png
          wallaby/not_found.png
          wallaby/not_implemented.png
          wallaby/unauthorized.png
          wallaby/unprocessable_entity.png
        )
    end
  end
end

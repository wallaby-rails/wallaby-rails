# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:partials` generator
    class PartialsGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../../../../../', __dir__)
      argument :name, type: :string, default: 'admin'

      # @see https://github.com/wallaby-rails/wallaby/blob/master/lib/generators/wallaby/engine/partials/USAGE
      def install
        destination_prefix = "app/views/#{file_name}/application"
        %w[
          _footer _frontend _logo _navs _title _user_menu
          _index_actions _index_filters _index_pagination _index_query _resource_navs
        ].each do |name|
          copy_file(
            "#{source_paths.first}/app/views/wallaby/resources/#{name}.html.erb",
            "#{destination_prefix}/#{name}.html.erb"
          )
        end
      end
    end
  end
end

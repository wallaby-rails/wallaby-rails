# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:install` generator
    class InstallGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string, default: 'admin'

      class_option \
        :mount_only,
        type: :boolean, default: false,
        aliases: :'-m',
        desc: 'Only mount Wallaby to given name.'

      class_option \
        :include_authorizer,
        aliases: :'-a',
        type: :boolean, default: false,
        desc: 'Include to generate application authorizer.'

      class_option \
        :include_paginator,
        aliases: :'-g',
        type: :boolean, default: false,
        desc: 'Include to generate application paginator.'

      class_option \
        :include_partials,
        aliases: :'-v',
        type: :string, default: nil,
        desc: 'Include to generate application partials'

      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/install/USAGE
      def install
        mount_wallaby_to_given_name
        return if options[:mount_only]

        create_wallaby_initializer_file
        create_application_files
      end

      protected

      # Helper method for the template to comment out a line
      def commenting
        (file_name == self.class.arguments.first.default && '# ') || ''
      end

      def mount_wallaby_to_given_name # :nodoc:
        route %(wallaby_mount at: '/#{file_name}')
      rescue StandardError => e
        Rails.logger.error "WARNING: #{e.message}"
      end

      def create_wallaby_initializer_file # :nodoc:
        template 'initializer.rb.erb', 'config/initializers/wallaby.rb'
      end

      def create_application_files # :nodoc:
        create_basic_files
        create_application_authorizer if options[:include_authorizer]
        create_application_paginator if options[:include_paginator]
        create_application_partials if options[:include_partials]
      end

      def create_basic_files # :nodoc:
        template 'application_controller.rb.erb', "app/controllers/#{file_name}/application_controller.rb"
        template 'application_decorator.rb.erb', "app/decorators/#{file_name}/application_decorator.rb"
        template 'application_servicer.rb.erb', "app/servicers/#{file_name}/application_servicer.rb"
      end

      def create_application_authorizer # :nodoc:
        template 'application_authorizer.rb.erb', "app/authorizers/#{file_name}/application_authorizer.rb"
      end

      def create_application_paginator # :nodoc:
        template 'application_paginator.rb.erb', "app/paginators/#{file_name}/application_paginator.rb"
      end

      def create_application_partials # :nodoc:
        task =
          case options[:include_partials]
          when 'include_partials', true then 'wallaby:engine:partials'
          else options[:include_partials]
          end
        invoke task, [name]
      end
    end
  end
end

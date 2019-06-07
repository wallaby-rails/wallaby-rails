module Wallaby
  # `wallaby:install` generator
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
      type: :boolean, default: false,
      desc: 'Include to generate application partials'

    # @see https://github.com/reinteractive/wallaby/blob/master/lib/generators/wallaby/install/USAGE
    def install
      mount_wallaby_to_given_name
      return if options[:mount_only]

      create_wallaby_initializer_file
      create_application_files
    end

    private

    def commenting
      file_name == self.class.arguments.first.default && '# ' || ''
    end

    def mount_wallaby_to_given_name
      route %(mount Wallaby::Engine, at: '/#{file_name}')
    rescue StandardError => e
      puts "WARNING: #{e.message}"
    end

    def create_wallaby_initializer_file
      template 'initializer.rb.erb', 'config/initializers/wallaby.rb'
    end

    def create_application_files
      create_basic_files
      create_application_authorizer if options[:include_authorizer]
      create_application_paginator if options[:include_paginator]
      create_application_partials if options[:include_partials]
    end

    def create_basic_files
      template 'application_controller.rb.erb', "app/controllers/#{file_name}/application_controller.rb"
      template 'application_decorator.rb.erb', "app/decorators/#{file_name}/application_decorator.rb"
      template 'application_servicer.rb.erb', "app/servicers/#{file_name}/application_servicer.rb"
    end

    def create_application_authorizer
      template 'application_authorizer.rb.erb', "app/authorizers/#{file_name}/application_authorizer.rb"
    end

    def create_application_paginator
      template 'application_paginator.rb.erb', "app/paginators/#{file_name}/application_paginator.rb"
    end

    def create_application_partials
      source_prefix = '../../../../../app/views/wallaby/resources'
      destination_prefix = "app/views/#{file_name}/application"
      %w(
        footer frontend logo navs title user_menu
        index_actions index_filters index_pagination index_query resource_navs
      ).each do |name|
        copy_file "#{source_prefix}/_#{name}.html.erb", "#{destination_prefix}/_#{name}.html.erb"
      end
    end
  end
end

# frozen_string_literal: true

# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    include Classifier

    # @!attribute [w] logger
    attr_writer :logger

    # @!attribute [r] logger
    def logger
      @logger ||= Rails.logger
    end

    # @!attribute [w] model_paths
    def model_paths=(*model_paths)
      @model_paths =
        model_paths.flatten.compact.presence.try do |paths|
          next paths if paths.all?(String)

          raise ArgumentError, 'Please provide a list of string paths, e.g. `["app/models", "app/core"]`'
        end
    end

    # @!attribute [r] model_paths
    # To configure the model folders that {Preloader} needs to load before everything else.
    # Default is `%w(app/models)`
    # @example To set the model paths
    #   Wallaby.config do |config|
    #     config.model_paths = ["app/models", "app/core"]
    #   end
    # @return [Array<String>] model paths
    # @since 0.2.2
    def model_paths
      @model_paths ||= %w[app/models]
    end

    # @!attribute [w] base_controller
    def base_controller=(base_controller)
      @base_controller = class_name_of base_controller
    end

    # @!attribute [r] base_controller
    # To globally configure the base controller class that {ResourcesController} should inherit from.
    #
    # If no configuration is given, {ResourcesController} defaults to inherit from **::ApplicationController**
    # from the host Rails app.
    # @example To update base controller to `CoreController` in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.base_controller = ::CoreController
    #   end
    # @return [Class] base controller class
    def base_controller
      to_class @base_controller ||= '::ApplicationController'
    end

    # @!attribute [w] resources_controller
    def resources_controller=(resources_controller)
      @resources_controller = class_name_of resources_controller
    end

    # @!attribute [r] resources_controller
    # To globally configure the application controller class that {Engine} should use.
    #
    # If no configuration is given, {Engine} defaults to use **Admin::ApplicationController** or
    # {Wallaby::ResourcesController}
    # from the host Rails app.
    # @example To update base controller to `CoreController` in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.resources_controller = ::CoreController
    #   end
    # @return [Class] base controller class
    # @since 0.2.3
    def resources_controller
      to_class(
        @resources_controller ||=
          (to_class('Admin::ApplicationController') && \
            'Admin::ApplicationController') || 'Wallaby::ResourcesController'
      )
    end

    # @return [Configuration::Models] models configuration for custom mode
    def custom_models
      @custom_models ||= ClassArray.new
    end

    # To globally configure the models for custom mode.
    # @example To update the model classes in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.custom_models = [Product, Order]
    #   end
    # @param models [Array<[Class, String]>] a list of model classes/name strings
    def custom_models=(models)
      @custom_models = ClassArray.new models.flatten
    end

    # @return [Configuration::Models] models configuration
    def models
      Deprecator.alert 'config.models.presence', from: '0.3.0', alternative: <<~INSTRUCTION
        Please use controller_class.models instead.
      INSTRUCTION
    end

    # To globally configure the models that Wallaby should handle.
    # @example To update the model classes in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.models = [Product, Order]
    #   end
    # @param models [Array<[Class, String]>] a list of model classes/name strings
    def models=(models)
      self.models.set models
    end

    # @return [Configuration::Security] security configuration
    def security
      @security ||= Security.new
    end

    # @return [Configuration::Mapping] mapping configuration
    def mapping
      @mapping ||= Mapping.new
    end

    # @return [Configuration::Metadata] metadata configuration
    def metadata
      @metadata ||= Metadata.new
    end

    # @return [Configuration::Pagination] pagination configuration
    def pagination
      @pagination ||= Pagination.new
    end

    # @return [Configuration::Features] features configuration
    def features
      @features ||= Features.new
    end

    # @return [Configuration::Sorting] sorting configuration
    def sorting
      Deprecator.alert 'config.sorting.strategy', from: '0.3.0', alternative: <<~INSTRUCTION
        Please use controller_class.sorting_strategy instead.
      INSTRUCTION
    end

    # Clear all configurations
    def clear
      instance_variables.each { |name| instance_variable_set name, nil }
    end
  end

  # @return [Configuration]
  def self.configuration
    @configuration ||= Configuration.new
  end

  # To config settings using a block
  # @example
  #   Wallaby.config do |c|
  #     c.pagination.page_size = 20
  #   end
  def self.config
    yield configuration
  end
end

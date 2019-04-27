# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    # @!attribute [w] base_controller
    attr_writer :base_controller

    # @!attribute [r] base_controller
    # To globally configure the base controller class that {Wallaby::ApplicationController} should inherit from.
    #
    # If no configuration is given, {Wallaby::ApplicationController} defaults to inherit from `::ApplicationController`
    # from the host Rails app.
    # @example To update base controller to `CoreController` in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.base_controller = ::CoreController
    #   end
    # @return [Class] base controller class
    def base_controller
      @base_controller ||= ::ApplicationController
    end

    # @return [Wallaby::Configuration::Models] models configuration for custom mode
    def custom_models
      @custom_models ||= Models.new
    end

    # To globally configure the models for custom mode.
    # @example To update the model classes in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.custom_models = [Product, Order]
    #   end
    # @param models [Array<[Class, String]>] a list of model classes/name strings
    def custom_models=(models)
      custom_models.set models
    end

    # @return [Wallaby::Configuration::Models] models configuration
    def models
      @models ||= Models.new
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

    # @return [Wallaby::Configuration::Security] security configuration
    def security
      @security ||= Security.new
    end

    # @return [Wallaby::Configuration::Mapping] mapping configuration
    def mapping
      @mapping ||= Mapping.new
    end

    # @return [Wallaby::Configuration::Metadata] metadata configuration
    def metadata
      @metadata ||= Metadata.new
    end

    # @return [Wallaby::Configuration::Pagination] pagination configuration
    def pagination
      @pagination ||= Pagination.new
    end

    # @return [Wallaby::Configuration::Features] features configuration
    def features
      @features ||= Features.new
    end

    # @return [Wallaby::Configuration::Sorting] sorting configuration
    def sorting
      @sorting ||= Sorting.new
    end

    # Clear all configurations
    def clear
      instance_variables.each { |name| instance_variable_set name, nil }
    end
  end

  # @return [Wallaby::Configuration]
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

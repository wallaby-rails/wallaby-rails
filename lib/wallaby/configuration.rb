# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    attr_writer :base_controller, :page_size

    # @return [Class]
    #   the controller that Wallaby should inherit from
    def base_controller
      @base_controller ||= ::ApplicationController
    end

    # @see Wallaby::Configuration#models= for configuration
    # @return [Wallaby::Configuration::Models]
    #   a list of models that Wallaby should handle
    def models
      @models ||= Models.new
    end

    # To configure the models that Wallaby should handle
    # @models [Array] a list of models
    def models=(models)
      self.models.set models
    end

    # @return [Wallaby::Configuration::Security]
    #   security configuration, mostly for authentication
    def security
      @security ||= Security.new
    end

    # @return [Wallaby::Configuration::Metadata] configuration of metadata
    def metadata
      @metadata ||= Metadata.new
    end

    # @return [Wallaby::Configuration::Pagination] pagination configuration
    def pagination
      @pagination ||= Pagination.new
    end

    # @return [Wallaby::Configuration::Features] configuration for features
    def features
      @features ||= Features.new
    end

    # Clear all configurations
    # @return nil
    def clear
      @base_controller, @models, @security, @pagination, @metadata,
      @features = []
    end
  end

  # @return [Wallaby::Configuration]
  def self.configuration
    @configuration ||= Configuration.new
  end

  # To config settings in below style
  # @example
  #   Wallaby.config do |c|
  #     c.pagination.page_size = 20
  #   end
  def self.config
    yield configuration
  end
end

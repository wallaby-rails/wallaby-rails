module Wallaby
  # Configuration helper module. Provide shortcut methods to configurations.
  module ConfigurationHelper
    # @return [Wallaby::Configuration] shortcut method of configuration
    def configuration
      Wallaby.configuration
    end

    # @return [Wallaby::Configuration::Models] shortcut method of models
    def models
      configuration.models
    end

    # @return [Wallaby::Configuration::Security] shortcut method of security
    def security
      configuration.security
    end

    # @return [Wallaby::Configuration::Mapping] shortcut method of mapping
    def mapping
      configuration.mapping
    end

    # @return [Wallaby::Configuration::Metadata] shortcut method of metadata
    def default_metadata
      configuration.metadata
    end

    # @return [Wallaby::Configuration::Pagination] shortcut method of pagination
    def pagination
      configuration.pagination
    end

    # @return [Wallaby::Configuration::Features] shortcut method of features
    def features
      configuration.features
    end
  end
end

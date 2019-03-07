module Wallaby
  # Configuration helper module. Provide shortcut methods to configurations.
  module ConfigurationHelper
    delegate :models, :security, :mapping, :pagination, :features, :sorting, to: :configuration

    # @return [Wallaby::Configuration] shortcut method of configuration
    def configuration
      Wallaby.configuration
    end

    # @return [Wallaby::Configuration::Metadata] shortcut method of metadata
    def default_metadata
      configuration.metadata
    end
  end
end

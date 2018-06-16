module Wallaby
  class Map
    # To collect model classes that are configured to be handled by Wallaby
    class ModelClassCollector
      # @param configuration [Configuration]
      # @param models [Array<Class>]
      def initialize(configuration, models = nil)
        @configuration = configuration
        @models = models || []
      end

      # @return [Array<Class>] model class
      def collect
        return @models - excluded_models if configured_models.blank?
        invalid_models_check
        configured_models
      end

      private

      # Check if the models are valid, raise if invalid
      def invalid_models_check
        invalid_models = configured_models - @models
        return if invalid_models.blank?
        message = I18n.t 'errors.invalid.models', models: invalid_models.to_sentence
        raise InvalidError, message
      end

      # @return [Wallaby::Configuration::Models]
      def models
        @configuration.models
      end

      # @return [Array<Class>] a list of models to exclude
      def excluded_models
        models.excludes
      end

      # @return [Array<Class>] a list of models to set
      def configured_models
        models.presence
      end
    end
  end
end

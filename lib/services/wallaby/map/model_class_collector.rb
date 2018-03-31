module Wallaby
  class Map
    # To collect model classes that are configured to be handled by Wallaby
    class ModelClassCollector
      # @param configuration [Configuration]
      def initialize(configuration)
        @configuration = configuration
      end

      # @return [Array<Class>] model class
      def collect
        return all_models - excluded_models if configured_models.blank?
        invalid_models_check
        configured_models
      end

      private

      # Check if the models are valid, raise if invalid
      def invalid_models_check
        invalid_models = configured_models - all_models
        return if invalid_models.blank?
        message = "#{invalid_models.to_sentence} are invalid models."
        raise InvalidError, message
      end

      # @return [Wallaby::Configuration::Models]
      def models
        @configuration.models
      end

      # @return [Array<Class>] all the models that modes recognize
      def all_models
        Map.mode_map.keys
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

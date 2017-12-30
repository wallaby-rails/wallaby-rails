module Wallaby
  class Map
    # To collect model classes that are configured to be handled by Wallaby
    class ModelClassCollector
      def initialize(configuration)
        @configuration = configuration
      end

      def collect
        return all_models - excluded_models if configured_models.blank?
        invalid_models_check
        configured_models
      end

      private

      def invalid_models_check
        invalid_models = configured_models - all_models
        return if invalid_models.blank?
        message = "#{invalid_models.to_sentence} are invalid models."
        raise InvalidError, message
      end

      def models
        @configuration.models
      end

      def all_models
        Map.mode_map.keys
      end

      def excluded_models
        models.excludes
      end

      def configured_models
        models.presence
      end
    end
  end
end

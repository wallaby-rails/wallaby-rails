module Wallaby
  class Configuration
    # Configuration for the model classes that Wallaby should handle
    # > NOTE: In `devlopment` environment, Rails recreates module/class
    # > constants on reload event. If we cache constants, they will become
    # > stale and raise conflicts.
    # > Hence, we need to storing name strings instead of constants.
    class Models
      # Specify the model classes that Wallaby should handle
      # @param models [Array<Class>]
      def set(*models)
        @models = Array(models).flatten.map(&:to_s)
      end

      # @return [Array<Class>, nil] the list of models that user has configured
      def presence
        (@models ||= []).map(&:constantize)
      end

      # Specify the model classes that user wants to exclude
      # @param models [Array<Class>]
      def exclude(*models)
        @excludes = Array(models).flatten.map(&:to_s)
      end

      # @return [Array<Class>] the list of models that user has configured
      def excludes
        (@excludes ||= []).map(&:constantize)
      end
    end
  end
end

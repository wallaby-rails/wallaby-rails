module Wallaby
  class Configuration
    # Configuration for the model classes that Wallaby should handle
    # > NOTE: In `devlopment` environment, Rails recreates module/class
    # > constants on reload event. If we cache constants, they will become
    # > stale and raise conflicts.
    # > Hence, we need to storing name strings instead of constants.
    class Models
      # Specify the model classes that Wallaby should handle
      def set(*models)
        @models = Array(models).flatten.map(&:to_s)
      end

      def presence
        @models.try(:map, &:constantize)
      end

      def excludes
        (@excludes ||= []).map(&:constantize)
      end

      def exclude(*models)
        @excludes = Array(models).flatten.map(&:to_s)
      end
    end
  end
end

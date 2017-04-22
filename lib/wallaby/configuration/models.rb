module Wallaby
  class Configuration
    # Models configuration
    class Models
      def set(*models)
        @models = Array(models).flatten
      end

      def presence
        @models.presence
      end

      def excludes
        @excludes ||= []
      end

      def exclude(*models)
        @excludes = Array(models).flatten
      end
    end
  end
end

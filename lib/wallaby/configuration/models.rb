module Wallaby
  class Configuration
    # Models configuration to specify the model classes that Wallaby should handle.
    # @note In `devlopment` environment, Rails recreates module/class constants on reload event.
    #   If constants are cached/stored, they will become stale and Rails will raise conflicts.
    #
    #   Hence, class name strings should be stored instead of constants.
    #   And when classes are requested, strings will be constantized back into classes.
    class Models
      # @note Once this is set, models exclusion configuration will be ignored.
      # To globally configure what model classes that Wallaby should handle.
      # @example To update the model classes in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models = [Product, Order]
      #   end
      # @param models [Array<Class>]
      def set(*models)
        @models = Array(models).flatten.map(&:to_s)
      end

      # Return the model classes that have been set.
      # @return [Array<Class>] a list of models
      def presence
        (@models ||= []).map(&:constantize)
      end

      # @note If models are {#set}, it will take precedence over models exclusion.
      # To globally configure what model classes to exclude.
      # @example To update the model classes exclusion in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models.exclude Product, Order
      #   end
      # @param models [Array<Class>]
      def exclude(*models)
        @excludes = Array(models).flatten.map(&:to_s)
      end

      # Return the model classes that should be excluded.
      # @return [Array<Class>] a list of models
      def excludes
        (@excludes ||= []).map(&:constantize)
      end
    end
  end
end

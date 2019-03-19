module Wallaby
  class Configuration
    # @note In `development` environment, Rails recreates module/class constants on reload event.
    #   If constants are cached/stored, they will become stale and Rails will raise conflicts.
    #
    #   Hence, class name strings should be stored instead.
    #   When classes are requested, strings will be constantized into classes.
    # Models configuration to specify the model classes that Wallaby should handle.
    class Models
      # @note If models are whitelisted, models exclusion will NOT be applied.
      # To globally configure what model classes that Wallaby should handle.
      # @example To whitelist the model classes in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models = [Product, Order]
      #   end
      # @param models [Array<Class, String>]
      def set(*models)
        @models = Array(models).flatten.map(&:to_s)
      end

      # @return [Array<Class>] the models configured
      def presence
        (@models ||= []).map(&:constantize)
      end

      # @note If models are whitelisted using {#set}, models exclusion will NOT be applied.
      # To globally configure what model classes to exclude.
      # @example To exclude models in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models.exclude Product, Order
      #   end
      # @param models [Array<Class, String>]
      def exclude(*models)
        @excludes = Array(models).flatten.map(&:to_s)
      end

      # @return [Array<Class>] the list of models to exclude.
      #   By default, `ActiveRecord::SchemaMigration` is excluded.
      def excludes
        (@excludes ||= ['ActiveRecord::SchemaMigration']).map(&:constantize)
      end
    end
  end
end

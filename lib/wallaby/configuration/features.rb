module Wallaby
  class Configuration
    # Features global configuration
    class Features
      # @!attribute [w] turbolinks_enabled
      attr_writer :turbolinks_enabled

      # @!attribute [r] turbolinks_enabled
      # To globally configure whether to use turbolinks or not.
      #
      # By default, turbolinks is disabled.
      # @example To enable turbolinks:
      #   Wallaby.config do |config|
      #     config.features.turbolinks_enabled = true
      #   end
      # @return [Boolean] a feture flag of turbolinks, default to false.
      def turbolinks_enabled
        @turbolinks_enabled ||= false
      end

      # @!attribute [w] sort_strategy
      attr_writer :sort_strategy

      # @!attribute [r] sort_strategy
      # To globally configure which strategy to use for sorting. Options are
      #
      #   - `:multiple`: support multiple columns sorting
      #   - `:single`: support single column sorting
      #
      # By default, strategy is `:multiple`.
      # @example To enable turbolinks:
      #   Wallaby.config do |config|
      #     config.features.sort_strategy = :single
      #   end
      # @return [Boolean] a feture flag of turbolinks, default to false.
      def sort_strategy
        @sort_strategy ||= :multiple
      end
    end
  end
end

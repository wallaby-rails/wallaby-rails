module Wallaby
  class Configuration
    # Sorting global configuration
    # @since 5.2.0
    class Sorting
      # @!attribute [w] strategy
      attr_writer :strategy

      # @!attribute [r] strategy
      # To globally configure which strategy to use for sorting. Options are
      #
      #   - `:multiple`: support multiple columns sorting
      #   - `:single`: support single column sorting
      #
      # By default, strategy is `:multiple`.
      # @example To enable turbolinks:
      #   Wallaby.config do |config|
      #     config.sorting.strategy = :single
      #   end
      # @return [Symbol, String]
      def strategy
        @strategy ||= :multiple
      end
    end
  end
end

module Wallaby
  class Configuration
    # Metadata configuration
    class Metadata
      # @!attribute [w] max
      attr_writer :max

      # @!attribute [r] resources_controller
      # @since 5.1.6
      # To globally configure max number of characters to display.
      # @example To update max number of characters to display to 50 in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.metadata.max = 50
      #   end
      # @return [Integer] max number of characters to display, default to 20
      def max
        @max ||= DEFAULT_MAX
      end
    end
  end
end

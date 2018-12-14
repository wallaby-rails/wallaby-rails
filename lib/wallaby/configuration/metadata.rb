module Wallaby
  class Configuration
    # Metadata configuration
    class Metadata
      # @!attribute [w] max
      attr_writer :max

      # @!attribute [r] resources_controller
      # To globally configure max number of characters to truncate.
      # @example To update max number of characters to truncate to 50 in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.metadata.max = 50
      #   end
      # @return [Integer] max number of characters to truncate, default to 20
      # @since 5.1.6
      def max
        @max ||= DEFAULT_MAX
      end
    end
  end
end

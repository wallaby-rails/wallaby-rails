module Wallaby
  class Configuration
    # Configuration for metadata
    class Metadata
      attr_writer :max

      # @return [Integer] max characters to display, default to 20
      def max
        @max ||= DEFAULT_MAX
      end
    end
  end
end

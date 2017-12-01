module Wallaby
  class Configuration
    # Configuration for metadata
    class Metadata
      attr_writer :max

      def max
        @max ||= DEFAULT_MAX
      end
    end
  end
end

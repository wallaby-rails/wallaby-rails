module Wallaby
  class Configuration
    # Configuration for metadata
    class Metadata
      def max
        @max ||= DEFAULT_MAX
      end

      def max=(max)
        @max = max
      end
    end
  end
end

module Wallaby
  class Configuration
    # Configuration for metadata
    class Features
      attr_writer :turbolinks_enabled

      def turbolinks_enabled
        @turbolinks_enabled ||= false
      end
    end
  end
end

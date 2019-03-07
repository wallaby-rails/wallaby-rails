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
    end
  end
end

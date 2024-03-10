# frozen_string_literal: true

module Wallaby
  class Configuration
    # Features global configuration
    class Features
      # @!attribute [w] turbolinks_enabled
      def turbolinks_enabled=(_turbolinks_enabled)
        Deprecator.alert 'config.features.turbolinks_enabled=', from: '0.3.0'
      end

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
        Deprecator.alert method(__callee__), from: '0.3.0', alternative: <<~INSTRUCTION
          If Turbolinks is included, it will be used by Wallaby. If you want to disable it,
          you can either take `turbolinks` gem out from your Gemfile
          or override the `frontend` partial by taking it out.
        INSTRUCTION
      end
    end
  end
end

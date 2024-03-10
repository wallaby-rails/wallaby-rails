# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    class Models
      # @deprecated
      def set(*_models)
        Deprecator.alert 'config.models.set', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set #models= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.models = User, 'Product'
            end
        INSTRUCTION
      end

      # @deprecated
      def presence
        Deprecator.alert 'config.models.presence', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.models instead.
        INSTRUCTION
      end

      # @deprecated
      def exclude(*_models)
        Deprecator.alert 'config.models.exclude', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set #models_to_exclude from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.models_to_exclude User, 'Product'
            end
        INSTRUCTION
      end

      # @deprecated
      def excludes
        Deprecator.alert 'config.models.excludes', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.models_to_exclude instead.
        INSTRUCTION
      end
    end
  end
end

# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    class Metadata
      # @deprecated
      def max=(_max)
        Deprecator.alert 'config.metadata.max=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set .max_text_length= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.max_text_length = 50
            end
        INSTRUCTION
      end

      # @deprecated
      def max
        Deprecator.alert 'config.metadata.max', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.max_text_length instead.
        INSTRUCTION
      end
    end
  end
end

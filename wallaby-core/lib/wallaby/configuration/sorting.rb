# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    class Sorting
      # @deprecated
      def strategy=(_strategy)
        Deprecator.alert 'config.sorting.strategy=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set #sorting_strategy= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.sorting_strategy = :multiple
            end
        INSTRUCTION
      end

      # @deprecated
      def strategy
        Deprecator.alert 'config.sorting.strategy', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.sorting_strategy instead.
        INSTRUCTION
      end
    end
  end
end

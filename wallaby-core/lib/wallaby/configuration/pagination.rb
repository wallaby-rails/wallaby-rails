# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    class Pagination
      # @deprecated
      def page_size=(_page_size)
        Deprecator.alert 'config.pagination.page_size=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set #page_size= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.page_size = 50
            end
        INSTRUCTION
      end

      # @deprecated
      def page_size
        Deprecator.alert 'config.pagination.page_size', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.page_size instead.
        INSTRUCTION
      end
    end
  end
end

# frozen_string_literal: true

module Wallaby
  class Custom
    # Model pagination provider for {Custom} mode
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      # By default, it doesn't support pagination
      # @return [false]
      def paginatable?
        false
      end
    end
  end
end

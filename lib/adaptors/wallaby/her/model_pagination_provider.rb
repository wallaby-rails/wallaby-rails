module Wallaby
  class Her
    # Model pagination provider
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      # By default, it doesn't support pagination as Her doesn't support
      # @return [false]
      def paginatable?
        false
      end
    end
  end
end

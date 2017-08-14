module Wallaby
  class ActiveRecord
    # Model operator
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      def paginatable?
        @collection.present?
      end

      def total
        @collection.total_count
      end

      def page_size
        (@params[:per] || Wallaby.configuration.page_size).to_i
      end

      def page_number
        [@params[:page].to_i, 1].max
      end
    end
  end
end

module Wallaby
  class ActiveRecord
    # Model pagination provider
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      # Check if collection has pagination feature
      # @return [Boolean]
      def paginatable?
        @collection.respond_to? :total_count
      end

      # Total count for the query
      # @return [Integer]
      def total
        @collection.total_count
      end

      # Page size
      # @return [Integer]
      def page_size
        (@params[:per] || Wallaby.configuration.page_size).to_i
      end

      # Page number
      # @return [Integer]
      def page_number
        [@params[:page].to_i, 1].max
      end
    end
  end
end

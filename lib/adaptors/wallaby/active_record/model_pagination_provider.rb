module Wallaby
  class ActiveRecord
    # Model pagination provider
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      # Check if collection has pagination feature
      # @return [Boolean]
      def paginatable?
        # `total_count` is a method that kaminari uses
        (@collection && @collection.respond_to?(:total_count)).tap do |paginatable|
          next if paginatable
          Rails.logger.warn I18n.t('errors.activerecord.paginatable', collection: @collection.inspect)
        end
      end

      # @return [Integer] total count for the query
      def total
        @collection.total_count
      end

      # @return [Integer] page size from parameters or configuration
      def page_size
        @params[:per].try(:to_i) || Wallaby.configuration.pagination.page_size
      end

      # @return [Integer] page number from parameters
      def page_number
        [@params[:page].to_i, 1].max
      end
    end
  end
end

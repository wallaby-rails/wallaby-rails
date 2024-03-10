# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # Model pagination provider for {Wallaby::ActiveRecord}
    class ModelPaginationProvider < ::Wallaby::ModelPaginationProvider
      # Check if collection can be paginated
      # @return [true] if paginatable
      # @return [false] if not paginatable
      def paginatable?
        (@collection.respond_to?(:unscope) && @collection.respond_to?(:count)).tap do |paginatable|
          Logger.warn "#{@collection} is not paginatable." unless paginatable
        end
      end

      # @return [Integer] total count for the collection
      def total
        @tatal ||= @collection.unscope(:offset, :limit).count # rubocop:disable CodeReuse/ActiveRecord
      end

      # @return [Integer] page size from parameters or Wallaby configuration
      def page_size
        @params[:per].to_i
      end

      # @return [Integer] page number from parameters starting from 1
      def page_number
        [@params[:page].to_i, 1].max
      end
    end
  end
end

module Wallaby
  class Configuration
    # Pagination configuration
    class Pagination
      # @!attribute [w] page_size
      attr_writer :page_size

      # @!attribute [r] page_size
      # To globally configure the page size for pagination.
      #
      # Page size can be one of the following values:
      #
      # - 10
      # - 20
      # - 50
      # - 100
      # @see Wallaby::PERS
      # @example To update the page size in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.pagination.page_size = 50
      #   end
      # @return [Integer] page size, default to 20
      def page_size
        @page_size ||= DEFAULT_PAGE_SIZE
      end
    end
  end
end

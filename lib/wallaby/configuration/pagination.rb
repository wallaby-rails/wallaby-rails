module Wallaby
  class Configuration
    # Configuration for pagination
    class Pagination
      attr_writer :page_size

      # @return [Integer] page size
      def page_size
        @page_size ||= DEFAULT_PAGE_SIZE
      end
    end
  end
end

module Wallaby
  class Configuration
    # Configuration for metadata
    class Pagination
      attr_writer :page_size

      def page_size
        @page_size ||= DEFAULT_PAGE_SIZE
      end
    end
  end
end

module Wallaby
  class Configuration
    # Pagination configuration
    class Pagination
      # @!attribute [w] page_size
      attr_writer :page_size

      # @!attribute [r] page_size
      # To globally configure the resources controller.
      # @example To update the model classes in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models = [Product, Order]
      #   end
      # @return [Integer] page size, default to 20
      def page_size
        @page_size ||= DEFAULT_PAGE_SIZE
      end
    end
  end
end

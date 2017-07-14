module Wallaby
  # Paginatable helper
  module PaginatableHelper
    def paginatable?(collection)
      defined?(::Kaminari) &&
        collection.present? && collection.respond_to?(:total_pages)
    end
  end
end

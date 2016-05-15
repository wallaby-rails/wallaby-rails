module Wallaby::PaginatableHelper
  def paginatable?(collection)
    defined?(Kaminari) && collection.present? && collection.respond_to?(:total_pages)
  end

  def custom_pagination_stats(collection)
    "Showing #{ content_tag :b, collection.size }".html_safe
  end
end

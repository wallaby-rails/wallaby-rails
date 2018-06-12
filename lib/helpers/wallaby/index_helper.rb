module Wallaby
  # Helper methods for index page
  module IndexHelper
    # Wrap the collection with paginator
    # @param model_class [Class]
    # @param collection [#map]
    # @param params [ActionController::Parameters]
    # @return [Wallaby::ResourcePaginator]
    def paginate(model_class, collection, params)
      Map.paginator_map(model_class).new model_class, collection, params
    end

    # Just a label
    # @return [String]
    def all_label
      t 'filters.all'
    end

    # Label for a given name
    # @param filter_name [String, Symbol]
    # @param filters [Hash]
    # @return [String]
    def filter_label(filter_name, filters)
      filters[filter_name].try(:[], :label) || filter_name.to_s.humanize
    end

    # Export link for a given model_class
    # @param model_class [Class]
    # @param url_params [Hash, ActionController::Parameters]
    # @return [String] HTML anchor link
    def export_link(model_class, url_params: {})
      url_params =
        index_params.except(:page, :per).merge(format: 'csv').merge(url_params)
      index_link model_class, url_params: url_params do
        t 'links.export', ext: 'CSV'
      end
    end

    # Link for a given model class and filter name
    # @param model_class [Class]
    # @param filter_name [String, Symbol]
    # @param filters [Hash]
    # @param url_params [Hash, ActionController::Parameters]
    # @return [String] HTML anchor link
    def filter_link(model_class, filter_name, filters: {}, url_params: {})
      is_all = filter_name == :all
      config = filters[filter_name] || {}
      label = is_all ? all_label : filter_label(filter_name, filters)
      url_params =
        if config[:default] then index_params.except(:filter).merge(url_params)
        else index_params.merge(filter: filter_name).merge(url_params)
        end
      index_link(model_class, url_params: url_params) { label }
    end

    # Sort link builder
    # @return [Sorting::LinkBuilder]
    def sort_link_builder
      @sort_link_builder ||=
        Sorting::LinkBuilder.new current_model_decorator, index_params, self
    end
  end
end

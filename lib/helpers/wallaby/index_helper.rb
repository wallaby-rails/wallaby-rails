module Wallaby
  # Helper methods for index page
  module IndexHelper
    def html_classes(string_or_array)
      { html_options: { class: string_or_array } }
    end

    def paginate(model_class, collection, parameters)
      Map.paginator_map(model_class).new model_class, collection, parameters
    end

    def all_label
      t 'filters.all'
    end

    def filter_label(filter_name, filters = current_model_decorator.filters)
      filters[filter_name].try(:[], :label) || filter_name.to_s.humanize
    end

    def current_filter_name(filter_name, filters)
      Utils.find_filter_name filter_name, filters
    end

    def export_link(model_class)
      export_params =
        { url_params: index_params.except(:page, :per).merge(format: 'csv') }
      index_link(model_class, export_params) { t 'links.export', ext: 'CSV' }
    end

    def filter_link(
      model_class, filter_name, filters = current_model_decorator.filters
    )
      is_all = filter_name == :all
      config = filters[filter_name] || {}
      url_params =
        if config[:default]
        then index_params.except(:filter)
        else index_params.merge(filter: filter_name)
        end
      index_link(model_class, url_params: url_params) do
        is_all ? all_label : filter_label(filter_name, filters)
      end
    end
  end
end

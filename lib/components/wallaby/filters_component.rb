module Wallaby
  # filters component
  class FiltersComponent < BaseComponent
    attr_reader :filters, :model_class

    def initialize(filters, model_class, view)
      @filters = filters
      @model_class = model_class
      super(view)
    end

    def build
      nav class: 'filters' do
        filters.present? ? filters_list : all_label
      end
    end

    private

    def filters_list
      concat a current_filter_name, **dropdown_options
      concat(ul do
        concat li em filters_title
        concat li filter_link(:all), html_options(:all)
        filters_list_buffer
      end)
    end

    def filters_list_buffer
      filters.each do |filter_name, _metadata|
        concat li filter_link(filter_name), html_options(filter_name)
      end
    end

    def filter_link(filter_name)
      is_all = filter_name == :all
      url_params =
        if is_all
          index_params.except(:filter)
        else
          index_params.merge(filter: filter_name)
        end
      index_link(model_class, url_params: url_params) do
        is_all ? all_label : filter_label(filter_name)
      end
    end

    def html_options(filter_name)
      current_filter == filter_name ? { class: 'filters--current' } : {}
    end

    def filter_label(filter_name)
      filters[filter_name].try(:[], :label) || filter_name.to_s.humanize
    end

    def current_filter_name
      filter_label(current_filter) || all_label
    end

    def current_filter
      index_params[:filter] || :all
    end

    def filters_title
      t 'filters.title'
    end

    def all_label
      t 'filters.all'
    end
  end
end

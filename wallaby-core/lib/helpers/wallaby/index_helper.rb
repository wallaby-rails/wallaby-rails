# frozen_string_literal: true

module Wallaby
  # Helper methods for index action
  module IndexHelper
    # Just a label
    # @return [String]
    def all_label
      wt 'filters.all'
    end

    # If `:fields` parameter is given, only display fields that is in `index_field_names`
    # Otherwise, `index_field_names`
    # @param decorated_collection [Array<Wallaby::ResourceDecorator>]
    # @param fields_from_params [Array<String>]
    # @return [Array<String>] a list of field names for json builder
    def json_fields_of(decorated_collection, fields_from_params = params[:fields])
      return [] if decorated_collection.blank?

      decorated = decorated_collection.first
      index_field_names = decorated.index_field_names.map(&:to_s)
      fields = (fields_from_params.presence || index_field_names).split(/\s*,\s*/).flatten
      fields & index_field_names
    end

    # @param filter_name [String, Symbol]
    # @param filters [Hash]
    # @return [String] filter label for the given field name
    def filter_label(filter_name, filters)
      # TODO: use locale for filter_name label
      filters[filter_name].try(:[], :label) || filter_name.to_s.humanize
    end

    # @param filter_name [String, Symbol]
    # @param filters [Hash]
    # @return [String] filter name
    # @see FilterUtils.filter_name_by
    def filter_name_by(filter_name, filters)
      FilterUtils.filter_name_by filter_name, filters
    end

    # Link for a given model class and filter name
    # @param model_class [Class]
    # @param filter_name [String, Symbol]
    # @param filters [Hash]
    # @param url_params [Hash, ActionController::Parameters]
    # @return [String] HTML anchor link
    def filter_link(model_class, filter_name, filters: {}, url_params: {}, html_options: {})
      is_all = filter_name == :all
      config = filters[filter_name] || {}
      label = is_all ? all_label : filter_label(filter_name, filters)
      url_params[:filter] = config[:default] ? nil : filter_name

      index_link(
        model_class,
        url_params: url_params.merge(with_query: true), html_options: html_options
      ) { label }
    end

    # @param model_class [Class]
    # @param url_params [Hash, ActionController::Parameters] extra URL params
    # @return [String] Export link for the given model_class.
    def export_link(model_class, url_params: {}, html_options: {})
      index_link(
        model_class,
        url_params: url_params.merge(format: 'csv', page: nil, per: nil, with_query: true),
        html_options: html_options
      ) do
        wt 'links.export', ext: 'CSV'
      end
    end

    # @return [Sorting::LinkBuilder]
    # @see Sorting::LinkBuilder
    def sort_link_builder(sorting_strategy = wallaby_controller.sorting_strategy)
      @sort_link_builder ||=
        Sorting::LinkBuilder.new(
          current_model_decorator, params.slice(:sort).permit!, self, sorting_strategy
        )
    end
  end
end

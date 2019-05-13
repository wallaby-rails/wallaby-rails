module Wallaby
  # Helper methods for index action
  module IndexHelper
    # @deprecated This method is no longer in use. It will be removed from 5.3.*
    def index_params(parameters = params)
      Utils.deprecate 'deprecation.index_params', caller: caller
      parameters
    end

    # @deprecated Use {Wallaby::Paginatable#current_paginator} instead. It will be removed from 5.3.*
    def paginator_of(_model_class, _collection, _params)
      Utils.deprecate 'deprecation.paginator_of', caller: caller
      current_paginator
    end

    # Just a label
    # @return [String]
    def all_label
      t 'filters.all'
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
    # @see Wallaby::FilterUtils.filter_name_by
    def filter_name_by(filter_name, filters)
      FilterUtils.filter_name_by filter_name, filters
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
      url_params[:filter] = config[:default] ? nil : filter_name
      index_link(model_class, options: { url: url_for(url_params.merge(with_query: true)) }) { label }
    end

    # @param model_class [Class]
    # @param url_params [Hash, ActionController::Parameters] extra URL params
    # @return [String] Export link for the given model_class.
    def export_link(model_class, url_params: {})
      index_link(model_class, url_params: { format: 'csv', page: nil, per: nil, with_query: true }.merge(url_params)) do
        t 'links.export', ext: 'CSV'
      end
    end

    # @return [Wallaby::Sorting::LinkBuilder]
    # @see Wallaby::Sorting::LinkBuilder
    def sort_link_builder
      @sort_link_builder ||=
        Sorting::LinkBuilder.new current_model_decorator, params.slice(:sort).permit!, self, sorting.strategy
    end
  end
end

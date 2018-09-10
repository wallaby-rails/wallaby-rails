module Wallaby
  # Helper methods for index action
  module IndexHelper
    # @param model_class [Class] model class
    # @param collection [#to_a] a collection of all the resources
    # @param params [ActionController::Parameters] parameters
    # @return [Wallaby::ModelPaginator]
    def paginator_of(model_class, collection, params)
      current_paginator_class.new(model_class, collection, params)
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

    # Label for a given name
    # @param filter_name [String, Symbol]
    # @param filters [Hash]
    # @return [String]
    def filter_label(filter_name, filters)
      filters[filter_name].try(:[], :label) || filter_name.to_s.humanize
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

    # Export link for a given model_class.
    # It accepts extra url params
    # @param model_class [Class]
    # @param url_params [Hash, ActionController::Parameters] extra URL params
    # @return [String] HTML anchor link
    def export_link(model_class, url_params: {})
      url_params = index_params.except(:page, :per).merge(format: 'csv').merge(url_params)
      index_link(model_class, url_params: url_params) { t 'links.export', ext: 'CSV' }
    end

    # Sort link builder
    # @return [Sorting::LinkBuilder]
    def sort_link_builder
      @sort_link_builder ||= Sorting::LinkBuilder.new current_model_decorator, index_params, self
    end
  end
end

module Wallaby
  # Model paginator
  class AbstractResourcePaginator
    # @return [Class] model class for paginator
    def self.model_class
      return unless self < ::Wallaby.configuration.mapping.resource_paginator
      Map.model_class_map name.gsub('Paginator', EMPTY_STRING)
    end

    # Delegate methods to pagination provider
    instance_methods =
      ModelPaginationProvider.instance_methods - ::Object.instance_methods
    delegate(*instance_methods, to: :@provider)

    # Paginator constructor
    # @param model_class [Class] model class
    # @param collection [#to_a] a collection of all the resources
    # @param params [ActionController::Parameters] parameters
    def initialize(model_class, collection, params)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'model class required' unless @model_class
      @collection = collection
      @params = params
      @provider =
        Map.pagination_provider_map(@model_class).new(@collection, @params)
    end
  end
end

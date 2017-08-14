module Wallaby
  # Model servicer
  class AbstractResourcePaginator
    def self.model_class
      return unless self < ::Wallaby::ResourcePaginator
      Map.model_class_map name.gsub('Paginator', EMPTY_STRING)
    end

    instance_methods =
      ModelPaginationProvider.instance_methods - ::Object.instance_methods
    delegate(*instance_methods, to: :@provider)

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

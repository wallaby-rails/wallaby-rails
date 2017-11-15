module Wallaby
  # Model servicer
  class AbstractModelServicer
    def self.model_class
      return unless self < ::Wallaby::ModelServicer
      Map.model_class_map name.gsub('Servicer', EMPTY_STRING)
    end

    def initialize(model_class = nil, authorizer = nil)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'model class required' unless @model_class
      @authorizer = authorizer
      @provider = Map.service_provider_map @model_class
    end

    def permit(params)
      @provider.permit params
    end

    def collection(params)
      @provider.collection params, @authorizer
    end

    def paginate(query, params)
      @provider.paginate query, params
    end

    def new(params)
      @provider.new params, @authorizer
    end

    def find(id, params)
      @provider.find id, params, @authorizer
    end

    def create(params)
      @provider.create params, @authorizer
    end

    def update(resource, params)
      @provider.update resource, params, @authorizer
    end

    def destroy(resource, params)
      @provider.destroy resource, params, @authorizer
    end
  end
end

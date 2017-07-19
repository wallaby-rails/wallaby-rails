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
      @handler = Map.handler_map @model_class
    end

    def collection(params)
      @handler.collection params, @authorizer
    end

    def new(params)
      @handler.new params, @authorizer
    end

    def find(id, params)
      @handler.find id, params, @authorizer
    end

    def create(params)
      @handler.create params, @authorizer
    end

    def update(resource, params)
      @handler.update resource, params, @authorizer
    end

    def destroy(resource, params)
      @handler.destroy resource, params, @authorizer
    end
  end
end

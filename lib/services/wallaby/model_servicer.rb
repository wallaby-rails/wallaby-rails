module Wallaby
  # Model servicer
  class ModelServicer
    def self.model_class
      return unless self < ::Wallaby::ModelServicer
      Map.model_class_map name.gsub('Servicer', EMPTY_STRING)
    end

    def initialize(model_class = nil)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'model class required' unless @model_class
      @handler = Map.handler_map @model_class
    end

    def collection(params, ability)
      @handler.collection params, ability
    end

    def new(params)
      @handler.new params
    end

    def find(id, params)
      @handler.find id, params
    end

    def create(params, ability)
      @handler.create params, ability
    end

    def update(resource, params, ability)
      @handler.update resource, params, ability
    end

    def destroy(resource, params)
      @handler.destroy resource, params
    end
  end
end

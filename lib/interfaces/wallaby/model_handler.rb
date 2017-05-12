module Wallaby
  # Model handler interface
  class ModelHandler
    def initialize(model_class, model_decorator = nil)
      raise ::ArgumentError, 'model class required' unless model_class
      @model_class = model_class
      @model_decorator = model_decorator || Map.model_decorator_map(model_class)
    end

    def collection(_params, _ability)
      raise NotImplemented
    end

    def new(_params)
      raise NotImplemented
    end

    def find(_id, _params)
      raise NotImplemented
    end

    def create(_params, _ability)
      raise NotImplemented
    end

    def update(_resource, _params, _ability)
      raise NotImplemented
    end

    def destroy(_resource, _params)
      raise NotImplemented
    end
  end
end

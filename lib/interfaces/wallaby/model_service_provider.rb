module Wallaby
  # Model service provider interface
  class ModelServiceProvider
    # @param model_class [Class] model class
    # @param model_decorator [Wallaby::ModelDecorator, nil] model decorator
    def initialize(model_class, model_decorator = nil)
      raise ::ArgumentError, 'model class required' unless model_class
      @model_class = model_class
      @model_decorator = model_decorator || Map.model_decorator_map(model_class)
    end

    # To whitelist params for a model class
    # @param _params [ActionController::Parameters]
    def permit(_params)
      raise NotImplemented
    end

    # Fetch collection by params
    # @param _params [ActionController::Parameters]
    # @param _authorizer
    def collection(_params, _authorizer)
      raise NotImplemented
    end

    # Paginate the records
    # @param _query
    # @param _params [ActionController::Parameters]
    def paginate(_query, _params)
      raise NotImplemented
    end

    # Initialize the model class using params
    # @param _params [ActionController::Parameters]
    # @param _authorizer
    def new(_params, _authorizer)
      raise NotImplemented
    end

    # Find a record using id
    # @param _id [Object]
    # @param _params [ActionController::Parameters]
    # @param _authorizer
    def find(_id, _params, _authorizer)
      raise NotImplemented
    end

    # Save the newly initialized resource
    # @param _resource [Object]
    # @param _params [ActionController::Parameters]
    # @param _authorizer
    def create(_resource, _params, _authorizer)
      raise NotImplemented
    end

    # Update the persisted resource
    # @param _resource [Object]
    # @param _params [ActionController::Parameters]
    # @param _authorizer
    def update(_resource, _params, _authorizer)
      raise NotImplemented
    end

    # Destroy the given resource
    # @param _resource [Object]
    # @param _params [ActionController::Parameters]
    # @param _authorizer
    def destroy(_resource, _params, _authorizer)
      raise NotImplemented
    end
  end
end

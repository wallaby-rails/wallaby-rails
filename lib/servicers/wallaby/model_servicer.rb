module Wallaby
  # Model servicer is used for {https://en.wikipedia.org/wiki/Create,_read,_update_and_delete CRUD} operations.
  # It contains a collection of CRUD methods (e.g. permit/paginate/collection/new/create/find/update/destroy).
  class ModelServicer < AbstractModelServicer
    # @param model_class [Class] model class
    # @param authorizer [Wallaby::ModelAuthorizer]
    # @param model_decorator [Wallaby::ModelDecorator] decorator
    def initialize(model_class:, authorizer:, model_decorator:)
      super
    end

    # This is the template method to whitelist attributes for mass assignment.
    # @param params [ActionController::Parameters, Hash]
    # @param action [String, Symbol]
    # @return [ActionController::Parameters] permitted params
    def permit(params, action = nil)
      super
    end

    # This is the template method to return a collection from query the datasource (e.g. database, REST API).
    #
    # It
    # @param params [ActionController::Parameters, Hash]
    # @return [Enumerable]
    def collection(params)
      super
    end

    # @param query [ActiveRecord::Relation]
    # @param params [ActionController::Parameters]
    # @return [ActiveRecord::Relation]
    def paginate(query, params)
      super
    end

    # @param params [ActionController::Parameters]
    # @return [Object] initialized object
    def new(params)
      super
    end

    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def find(id, params)
      super
    end

    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def create(resource, params)
      super
    end

    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def update(resource, params)
      super
    end

    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def destroy(resource, params)
      super
    end
  end
end

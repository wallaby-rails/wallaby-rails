module Wallaby
  # Model servicer is used for {https://en.wikipedia.org/wiki/Create,_read,_update_and_delete CRUD} operations.
  class ModelServicer < AbstractModelServicer
    # @param model_class [Class] model class
    # @param authorizer [Wallaby::ModelAuthorizer]
    # @param model_decorator [Wallaby::ModelDecorator]
    def initialize(model_class:, authorizer:, model_decorator:)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to whitelist attributes for mass assignment.
    # @param params [ActionController::Parameters, Hash]
    # @param action [String, Symbol]
    # @return [ActionController::Parameters] permitted params
    def permit(params, action = nil)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to return a collection from querying the datasource (e.g. database, REST API).
    # @param params [ActionController::Parameters, Hash]
    # @return [Enumerable]
    def collection(params)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to paginate a {#collection}.
    # @param query [Enumerable]
    # @param params [ActionController::Parameters]
    # @return [Enumerable]
    def paginate(query, params)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to initialize an instance for its model class.
    # @param params [ActionController::Parameters]
    # @return [Object] initialized object
    def new(params)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to find a record.
    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def find(id, params)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to create a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def create(resource, params)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to update a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def update(resource, params)
      super
    end

    # @note It can be overriden in subclasses for customization purpose.
    # This is the template method to delete a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def destroy(resource, params)
      super
    end
  end
end

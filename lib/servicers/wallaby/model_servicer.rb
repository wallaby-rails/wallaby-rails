module Wallaby
  # Model servicer is used for {https://en.wikipedia.org/wiki/Create,_read,_update_and_delete CRUD} operations.
  class ModelServicer < AbstractModelServicer
    # @param model_class [Class] model class
    # @param authorizer [Wallaby::ModelAuthorizer]
    # @param model_decorator [Wallaby::ModelDecorator]
    def initialize(model_class, authorizer, model_decorator)
      super
    end

    # @!method permit(params, action = nil)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to whitelist attributes for mass assignment.
    #
    # When speaking in Rails language, Wallaby does the whitlisting the same affect as below:
    #
    # ```
    # params.require(:user).permit(:email, :first_name, :last_name)
    # ```
    #
    # But automatically.
    # @param params [ActionController::Parameters, Hash]
    # @param action [String, Symbol]
    # @return [ActionController::Parameters] permitted params

    # @!method collection(params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to return a collection from querying the datasource (e.g. database, REST API).
    # @param params [ActionController::Parameters, Hash]
    # @return [Enumerable]

    # @!method paginate(query, params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to paginate a {#collection}.
    # @param query [Enumerable]
    # @param params [ActionController::Parameters]
    # @return [Enumerable]

    # @!method new(params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to initialize an instance for its model class.
    # @param params [ActionController::Parameters]
    # @return [Object] initialized object

    # @!method find(id, params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to find a record.
    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object

    # @!method create(resource, params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to create a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object

    # @!method update(resource, params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to update a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object

    # @!method destroy(resource, params)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to delete a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
  end
end

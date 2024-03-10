# frozen_string_literal: true

module Wallaby
  # This is the base servicer class to provider data source related operations
  # for given/associated model. In general, it works together with {#authorizer}
  # to ensure that all operations are legitmate.
  #
  # For best practice, please create an application servicer class (see example)
  # to better control the functions shared between different model servicers.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationServicer < Wallaby::ModelServicer
  #     base_class!
  #   end
  class ModelServicer
    extend Baseable::ClassMethods
    base_class!

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] model_decorator
    # @return [ModelDecorator]
    # @since wallaby-5.2.0
    attr_reader :model_decorator

    # @!attribute [r] authorizer
    # @return [ModelAuthorizer]
    # @since wallaby-5.2.0
    attr_reader :authorizer

    # @!attribute [r] provider
    # @return [ModelServiceProvider] the instance that does the job
    # @since wallaby-5.2.0
    attr_reader :provider

    # @!method user
    # @return [Object]
    # @since wallaby-5.2.0
    delegate :user, to: :authorizer

    # @param model_class [Class]
    # @param authorizer [ModelAuthorizer]
    # @param model_decorator [ModelDecorator]
    # @raise [ArgumentError] if model_class is blank
    def initialize(model_class, authorizer, model_decorator)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'Please provide a `model_class`.' unless @model_class

      @model_decorator = model_decorator
      @authorizer = authorizer
      @provider = Map.service_provider_map(@model_class).new(@model_class, @model_decorator)
    end

    # @note This is a template method that can be overridden by subclasses.
    # Allowlist parameters for mass assignment.
    # @param params [Hash, ActionController::Parameters]
    # @param action [String, Symbol, nil]
    # @return [ActionController::Parameters] permitted params
    def permit(params, action = nil)
      provider.permit params, action, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # Return a collection by querying the datasource (e.g. database, REST API).
    # @param params [Hash, ActionController::Parameters]
    # @return [Enumerable] list of resources
    def collection(params)
      provider.collection params, authorizer
    end

    # @!method paginate(query, params)
    # @note This is a template method that can be overridden by subclasses.
    # Paginate given {#collection}.
    # @param query [Enumerable]
    # @param params [ActionController::Parameters]
    # @return [Enumerable] list of resources
    delegate :paginate, to: :provider

    # @note This is a template method that can be overridden by subclasses.
    # Initialize an instance of the model class.
    # @param params [ActionController::Parameters]
    # @return [Object] initialized resource
    def new(params = {})
      provider.new params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To find a resource.
    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] found resource
    def find(id, params = {})
      provider.find id, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To create a resource.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] created resource
    def create(resource, params)
      provider.create resource, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To update a resource.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource
    def update(resource, params)
      provider.update resource, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To delete a resource.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource
    def destroy(resource, params = {})
      provider.destroy resource, params, authorizer
    end
  end
end

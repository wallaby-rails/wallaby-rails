module Wallaby
  # Model servicer contains resourceful operations for Rails resourceful actions.
  class ModelServicer
    extend Baseable::ClassMethods

    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return associated model class, e.g. return **Product** for **ProductServicer**.
      #
      # If Wallaby can't recognise the model class for Servicer, it's required to be configured as below example:
      # @example To configure model class
      #   class Admin::ProductServicer < Admin::ApplicationServicer
      #     self.model_class = Product
      #   end
      # @example To configure model class for version below 5.2.0
      #   class Admin::ProductServicer < Admin::ApplicationServicer
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assoicated model class
      # @return [nil] if current class is marked as base class
      # @return [nil] if current class is the same as the value of {Wallaby::Configuration::Mapping#model_servicer}
      # @return [nil] if current class is {Wallaby::ModelServicer}
      # @return [nil] if assoicated model class is not found
      def model_class
        return unless self < ModelServicer
        return if base_class? || self == Wallaby.configuration.mapping.model_servicer
        @model_class ||= Map.model_class_map(name.gsub(/(^#{namespace}::)|(Servicer$)/, EMPTY_STRING))
      end

      # @!attribute provider_class
      # @return [Class] service provider class
      # @since 5.2.0
      attr_accessor :provider_class
    end

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] model_decorator
    # @return [Wallaby::ModelDecorator]
    # @since 5.2.0
    attr_reader :model_decorator

    # @!attribute [r] authorizer
    # @return [Wallaby::ModelAuthorizer]
    # @since 5.2.0
    attr_reader :authorizer

    # @!attribute [r] provider
    # @return [Wallaby::ModelServiceProvider]
    # @since 5.2.0
    attr_reader :provider

    # @!method user
    # @return [Object]
    # @since 5.2.0
    delegate :user, to: :authorizer

    # During initialization, Wallaby will assign a service provider for this servicer
    # to carry out the actual execution.
    #
    # Therefore, all its actions can be completely replaced by user's own implemnetation.
    # @param model_class [Class]
    # @param authorizer [Wallaby::ModelAuthorizer]
    # @param model_decorator [Wallaby::ModelDecorator]
    # @raise [ArgumentError] if param model_class is blank
    def initialize(model_class, authorizer, model_decorator = nil)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, I18n.t('errors.required', subject: 'model_class') unless @model_class
      @model_decorator = model_decorator || Map.model_decorator_map(model_class)
      @authorizer = authorizer
      provider_class = self.class.provider_class || Map.service_provider_map(@model_class)
      @provider = provider_class.new(@model_class, @model_decorator)
    end

    # @note This is a template method that can be overridden by subclasses.
    # Whitelist parameters for mass assignment.
    # @param params [ActionController::Parameters, Hash]
    # @param action [String, Symbol]
    # @return [ActionController::Parameters] permitted params
    def permit(params, action = nil)
      provider.permit params, action, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # Return a collection by querying the datasource (e.g. database, REST API).
    # @param params [ActionController::Parameters, Hash]
    # @return [Enumerable] list of records
    def collection(params)
      provider.collection params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # Paginate given {#collection}.
    # @param query [Enumerable]
    # @param params [ActionController::Parameters]
    # @return [Enumerable] list of records
    def paginate(query, params)
      provider.paginate query, params
    end

    # @note This is a template method that can be overridden by subclasses.
    # Initialize an instance of the model class.
    # @param params [ActionController::Parameters]
    # @return [Object] initialized object
    def new(params)
      provider.new params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To find a record.
    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def find(id, params)
      provider.find id, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To create a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def create(resource, params)
      provider.create resource, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To update a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def update(resource, params)
      provider.update resource, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To delete a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def destroy(resource, params)
      provider.destroy resource, params, authorizer
    end
  end
end

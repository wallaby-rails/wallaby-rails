module Wallaby
  # Abstract model servicer
  class AbstractModelServicer
    extend Abstractable::ClassMethods
    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return the assoicated model class.
      #
      # If model class is not set, Wallaby will try to get it from current class.
      # For instance, if current class is **ProductServicer**, then Wallaby will return model class **Product**.
      #
      # However, if current class is **Admin::ProductServicer**, it's needed to configure the model class as in the
      # example
      # @example To set model class
      #   class Admin::ProductServicer < Admin::ApplicationServicer
      #     self.model_class = Product
      #   end
      # @return [Class] assoicated model class
      def model_class
        return unless self < ModelServicer
        return if abstract || self == Wallaby.configuration.mapping.model_servicer
        @model_class ||= Map.model_class_map(name.gsub('Servicer', EMPTY_STRING))
      end
    end

    # @param model_class [Class] model class
    # @param authorizer [Wallaby::ModelAuthorizer]
    # @param model_decorator [Wallaby::ModelServicer]
    def initialize(model_class, authorizer, model_decorator)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'model class required' unless @model_class
      @authorizer = authorizer
      @provider = Map.service_provider_map(@model_class).new(@model_class, model_decorator)
    end

    # This is the template method to whitelist attributes for mass assignment.
    # @param params [ActionController::Parameters, Hash]
    # @param action [String, Symbol]
    # @return [ActionController::Parameters] permitted params
    def permit(params, action = nil)
      @provider.permit params, action, @authorizer
    end

    # This is the template method to return a collection from querying the datasource (e.g. database, REST API).
    # @param params [ActionController::Parameters, Hash]
    # @return [Enumerable]
    def collection(params)
      @provider.collection params, @authorizer
    end

    # This is the template method to paginate a {#collection}.
    # @param query [Enumerable]
    # @param params [ActionController::Parameters]
    # @return [Enumerable]
    def paginate(query, params)
      @provider.paginate query, params
    end

    # This is the template method to initialize an instance for its model class.
    # @param params [ActionController::Parameters]
    # @return [Object] initialized object
    def new(params)
      @provider.new params, @authorizer
    end

    # This is the template method to find a record.
    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def find(id, params)
      @provider.find id, params, @authorizer
    end

    # This is the template method to create a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def create(resource, params)
      @provider.create resource, params, @authorizer
    end

    # This is the template method to update a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def update(resource, params)
      @provider.update resource, params, @authorizer
    end

    # This is the template method to delete a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def destroy(resource, params)
      @provider.destroy resource, params, @authorizer
    end
  end
end

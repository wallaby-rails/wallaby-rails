module Wallaby
  # Abstract model servicer
  class AbstractModelServicer
    # @return [Class] model class that comes from its class name
    def self.model_class
      return unless self < ::Wallaby.configuration.mapping.model_servicer
      Map.model_class_map name.gsub('Servicer', EMPTY_STRING)
    end

    # @param model_class [Class, nil] model class
    # @param authorizer [Ability]
    def initialize(model_class = nil, authorizer = nil)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'model class required' unless @model_class
      @authorizer = authorizer
      @provider = Map.service_provider_map @model_class
    end

    # @param params [ActionController::Parameters]
    # @return [ActionController::Parameters]
    def permit(params)
      @provider.permit params
    end

    # @param params [ActionController::Parameters]
    # @return [ActiveRecord::Relation]
    def collection(params)
      @provider.collection params, @authorizer
    end

    # @param query [ActiveRecord::Relation]
    # @param params [ActionController::Parameters]
    # @return [ActiveRecord::Relation]
    def paginate(query, params)
      @provider.paginate query, params
    end

    # @param params [ActionController::Parameters]
    # @return [Object] initialized object
    def new(params)
      @provider.new params, @authorizer
    end

    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def find(id, params)
      @provider.find id, params, @authorizer
    end

    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def create(resource, params)
      @provider.create resource, params, @authorizer
    end

    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def update(resource, params)
      @provider.update resource, params, @authorizer
    end

    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def destroy(resource, params)
      @provider.destroy resource, params, @authorizer
    end
  end
end

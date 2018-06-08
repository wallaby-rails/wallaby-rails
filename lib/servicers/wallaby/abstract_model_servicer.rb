module Wallaby
  # Abstract model servicer
  class AbstractModelServicer
    class << self
      attr_writer :model_class
      # @return [Class] model class that comes from its class name
      def model_class
        return unless self < ModelServicer
        @model_class || Map.model_class_map(name.gsub('Servicer', EMPTY_STRING))
      end
    end

    # @param model_class [Class, nil] model class
    # @param authorizer [Ability]
    def initialize(model_class = nil, authorizer = nil)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, 'model class required' unless @model_class
      @authorizer = authorizer
      @provider = Map.service_provider_map(@model_class).new(@model_class)
    end

    # @param params [ActionController::Parameters]
    # @return [ActionController::Parameters]
    def permit(params, action = nil)
      @provider.permit params, action, @authorizer
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

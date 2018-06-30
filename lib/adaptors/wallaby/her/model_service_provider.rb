module Wallaby
  class Her
    # Model service provider
    # @see Wallaby::ModelServiceProvider
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # Only the general fields will be permitted.
      # It's less possible to guess what nested attributes should be permitted.
      # @see Wallaby::ModelServiceProvider#permit
      # @param params [ActionController::Parameters]
      # @return [ActionController::Parameters] whitelisted parameters
      def permit(params)
        params.require(param_key).permit permitted_fields
      end

      # No general practices of how ordering and searching can be done in Her.
      # Therefore, it will just return all
      #
      # NOTE: pagination free here.
      # Since somewhere might need the collection without any pagination
      # @see Wallaby::ModelServiceProvider#collection
      # @param _params [ActionController::Parameters]
      # @param _authorizer [Ability] for now
      # @return [ActiveRecord::Relation]
      def collection(_params, _authorizer)
        @model_class.all
      end

      # No general practices of how pagination can be done in Her.
      # Therefore, it will just return all
      #
      # @see Wallaby::ModelServiceProvider#paginate
      # @param query [ActiveRecord::Relation]
      # @param _params [ActionController::Parameters]
      # @return [ActiveRecord::Relation] paginated query
      def paginate(query, _params)
        query.all
      end

      # @see Wallaby::ModelServiceProvider#new
      # @param permitted_params [ActionController::Parameters]
      def new(permitted_params, _authorizer)
        @model_class.new permitted_params.to_h
      end

      # @see Wallaby::ModelServiceProvider#find
      # @param id [String]
      # @param permitted_params [ActionController::Parameters]
      def find(id, permitted_params, _authorizer)
        resource = @model_class.find id
        raise ResourceNotFound, id unless resource
        resource.assign_attributes permitted_params.to_h
        resource
      end

      # @see Wallaby::ModelServiceProvider#create
      # @param resource_with_new_value [Object]
      # @param params [ActionController::Parameters]
      def create(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#update
      # @param resource_with_new_value [Object]
      # @param params [ActionController::Parameters]
      def update(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#destroy
      # @param resource [Object]
      # @param _params [ActionController::Parameters]
      def destroy(resource, _params, _authorizer)
        resource.destroy
      end

      protected

      # Save the active record
      # @param action [String] `create`, `update`
      # @param resource [Object]
      # @param _params [ActionController::Parameters]
      # @param authorizer [Object]
      # @return resource itself
      def save(action, resource, _params, authorizer)
        ensure_attributes_for authorizer, action, resource
        resource.save if resource.valid?
        resource
      end

      # To make sure that the record can be updated with the values that are
      # allowed to.
      # @param authorizer [Object]
      # @param action [String]
      # @param resource [Object]
      def ensure_attributes_for(authorizer, action, resource)
        return if authorizer.blank?
        restricted_conditions = authorizer.attributes_for action, resource
        resource.assign_attributes restricted_conditions
      end

      # @return [String] the params key
      def param_key
        @model_class.model_name.param_key
      end

      # The list of attributes to whitelist.
      # For now, only general fields can be whitelisted.
      # @return [Array]
      def permitted_fields
        @permitted_fields ||=
          @model_decorator.fields.reject do |_field_name, metadata|
            metadata[:is_association]
          end.keys
      end
    end
  end
end

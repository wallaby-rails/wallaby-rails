module Wallaby
  class Her
    # Model service provider for HER ORM
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # Only the general fields will be permitted.
      # It's less possible to guess what nested attributes should be permitted.
      # @see Wallaby::ModelServiceProvider#permit
      # @param params [ActionController::Parameters]
      # @return [ActionController::Parameters] whitelisted parameters
      def permit(params, action, authorizer)
        authorized_fields = authorizer.permit_params action, @model_class
        params.require(param_key).permit(authorized_fields || permitted_fields)
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
      def new(_params, _authorizer)
        @model_class.new
      end

      # @see Wallaby::ModelServiceProvider#find
      # @param id [String]
      def find(id, _params, _authorizer)
        resource = @model_class.find id
        raise ResourceNotFound, id unless resource
        resource
      end

      # @see Wallaby::ModelServiceProvider#create
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      def create(resource, params, authorizer)
        save __callee__, resource, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#update
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      def update(resource, params, authorizer)
        save __callee__, resource, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#destroy
      # @param resource [Object]
      # @param _params [ActionController::Parameters]
      def destroy(resource, _params, _authorizer)
        resource.destroy
      end

      protected

      # Save the record
      # @param action [String] `create`, `update`
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      # @param authorizer [Object]
      # @return resource itself
      def save(action, resource, params, authorizer)
        resource.assign_attributes params.to_h
        ensure_attributes_for authorizer, action, resource
        resource.save if resource.valid?
        resource
      rescue ActionController::UnfilteredParameters => e
        resource.errors.add :base, e.message
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

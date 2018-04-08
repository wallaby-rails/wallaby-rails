module Wallaby
  class Her
    # Model service provider
    # @see Wallaby::ModelServiceProvider
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # @see Wallaby::ModelServiceProvider#permit
      # @param params [ActionController::Parameters]
      # @return [ActionController::Parameters] whitelisted parameters
      def permit(params)
        params.require(param_key).permit permitted_fields
      end

      # NOTE: pagination free here.
      # Since somewhere might need the collection without any pagination
      # @see Wallaby::ModelServiceProvider#collection
      # @param params [ActionController::Parameters]
      # @param _authorizer [Ability] for now
      # @return [ActiveRecord::Relation]
      def collection(params, _authorizer)
        query = @model_class
        query = query.where sort: params[:sort] if params[:sort].present?
        query.all
      end

      # Paginate
      # @see Wallaby::ModelServiceProvider#paginate
      # @param query [ActiveRecord::Relation]
      # @param params [ActionController::Parameters]
      # @param [ActiveRecord::Relation] paginated query
      def paginate(query, params)
        per = params[:per] || Wallaby.configuration.pagination.page_size
        query = query.where page: params[:page] if params[:page]
        query = query.where per: per
        query
      end

      # @see Wallaby::ModelServiceProvider#new
      def new(permitted_params, _authorizer)
        @model_class.new permitted_params
      end

      # @see Wallaby::ModelServiceProvider#find
      def find(id, permitted_params, _authorizer)
        resource = @model_class.find id
        raise ResourceNotFound, id unless resource
        resource.assign_attributes permitted_params
        resource
      end

      # @see Wallaby::ModelServiceProvider#create
      def create(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#update
      def update(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      # @see Wallaby::ModelServiceProvider#destroy
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

      # The params key
      def param_key
        @model_class.model_name.param_key
      end

      # The list of attributes to whitelist
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

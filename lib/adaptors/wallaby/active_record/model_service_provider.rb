module Wallaby
  class ActiveRecord
    # Model service provider
    # @see Wallaby::ModelServiceProvider
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # @see Wallaby::ModelServiceProvider#permit
      # @param params [ActionController::Parameters]
      # @param action [String, Symbol]
      # @param authorizer
      # @return [ActionController::Parameters] whitelisted parameters
      def permit(params, action, authorizer)
        authorized_fields = authorizer.permit_params action, @model_class
        params.require(param_key).permit(authorized_fields || permitted_fields)
      end

      # NOTE: pagination free here.
      # Since somewhere might need the collection without any pagination
      # @see Wallaby::ModelServiceProvider#collection
      # @param params [ActionController::Parameters]
      # @param authorizer [Ability] for now
      # @return [ActiveRecord::Relation]
      def collection(params, authorizer)
        query = querier.search params
        query = query.order params[:sort] if params[:sort].present?
        authorizer.accessible_for :index, query
      end

      # Paginate
      # @see Wallaby::ModelServiceProvider#paginate
      # @param query [ActiveRecord::Relation]
      # @param params [ActionController::Parameters]
      # @param [ActiveRecord::Relation] paginated query
      def paginate(query, params)
        per = params[:per] || Wallaby.configuration.pagination.page_size
        query = query.page params[:page] if query.respond_to? :page
        query = query.per per if query.respond_to? :per
        query
      end

      # @see Wallaby::ModelServiceProvider#new
      # @param permitted_params [ActionController::Parameters]
      def new(permitted_params, _authorizer)
        @model_class.new normalize permitted_params
      rescue ::ActiveModel::UnknownAttributeError
        @model_class.new
      end

      # @see Wallaby::ModelServiceProvider#find
      # @param id [Integer, String]
      # @param permitted_params [ActionController::Parameters]
      def find(id, permitted_params, _authorizer)
        resource = @model_class.find id
        resource.assign_attributes normalize permitted_params
        resource
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound, id
      rescue ::ActiveModel::UnknownAttributeError
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

      # Save the ActiveRecord
      # @param action [String] `create`, `update`
      # @param resource [Object]
      # @param _params [ActionController::Parameters]
      # @param authorizer [Object]
      # @return resource itself
      def save(action, resource, _params, authorizer)
        ensure_attributes_for authorizer, action, resource
        resource.save if valid? resource
        resource
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        resource
      end

      # Normalize params
      # @param params [ActionController::Parameters]
      def normalize(params)
        normalizer.normalize params
      end

      # See if a resource is valid
      # @param resource [Object]
      # @return [Boolean]
      def valid?(resource)
        validator.valid? resource
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
          permitter.simple_field_names << permitter.compound_hashed_fields
      end

      # @see Wallaby::ModelServiceProvider::Permitter
      def permitter
        @permitter ||= Permitter.new @model_decorator
      end

      # @see Wallaby::ModelServiceProvider::Querier
      def querier
        @querier ||= Querier.new @model_decorator
      end

      # @see Wallaby::ModelServiceProvider::Normalizer
      def normalizer
        @normalizer ||= Normalizer.new @model_decorator
      end

      # @see Wallaby::ModelServiceProvider::Validator
      def validator
        @validator ||= Validator.new @model_decorator
      end
    end
  end
end

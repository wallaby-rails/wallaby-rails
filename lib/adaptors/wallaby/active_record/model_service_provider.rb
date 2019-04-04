module Wallaby
  class ActiveRecord
    # Model service provider
    # @see Wallaby::ModelServiceProvider
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # @param params [ActionController::Parameters]
      # @param action [String, Symbol]
      # @param authorizer
      # @return [ActionController::Parameters] whitelisted parameters
      # @see Wallaby::ModelServiceProvider#permit
      def permit(params, action, authorizer)
        authorized_fields = authorizer.permit_params action, @model_class
        params.require(param_key).permit(authorized_fields || permitted_fields)
      end

      # @note Pagination free here. Since somewhere might need the collection without any pagination
      # @param params [ActionController::Parameters]
      # @param authorizer [Ability] for now
      # @return [ActiveRecord::Relation] relation
      # @see Wallaby::ModelServiceProvider#collection
      def collection(params, authorizer)
        query = querier.search params
        query = query.order params[:sort] if params[:sort].present?
        authorizer.accessible_for :index, query
      end

      # @param query [ActiveRecord::Relation]
      # @param params [ActionController::Parameters]
      # @return [ActiveRecord::Relation] paginated query
      # @see Wallaby::ModelServiceProvider#paginate
      def paginate(query, params)
        per = params[:per] || Wallaby.configuration.pagination.page_size
        query = query.page params[:page] if query.respond_to? :page
        query = query.per per if query.respond_to? :per
        query
      end

      # @note No mass assignment happens here!
      # @return [Object] new resource object
      # @see Wallaby::ModelServiceProvider#new
      def new(_params, _authorizer)
        @model_class.new
      end

      # @note No mass assignment happens here!
      # Find the record using id.
      # @param id [Integer, String]
      # @return [Object] persisted resource object
      # @raise [Wallaby::ResourceNotFound] when record is not found
      # @see Wallaby::ModelServiceProvider#find
      def find(id, _params, _authorizer)
        @model_class.find id
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound, id
      end

      # Assign resource with new values and store it in database as new record.
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      # @param authorizer [Wallaby::ModelAuthorizer]
      # @see Wallaby::ModelServiceProvider#create
      def create(resource, params, authorizer)
        save __callee__, resource, params, authorizer
      end

      # Assign resource with new values and store it in database as an update.
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      # @param authorizer [Wallaby::ModelAuthorizer]
      # @see Wallaby::ModelServiceProvider#update
      def update(resource, params, authorizer)
        save __callee__, resource, params, authorizer
      end

      # Remove a record from database
      # @param resource [Object]
      # @see Wallaby::ModelServiceProvider#destroy
      def destroy(resource, _params, _authorizer)
        resource.destroy
      end

      protected

      # Save the record
      # @param action [String] `create`, `update`
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      # @param authorizer [Wallaby::ModelAuthorizer]
      # @return resource itself
      # @raise [ActiveRecord::StatementInvalid, ActiveModel::UnknownAttributeError, ActiveRecord::UnknownAttributeError]
      def save(action, resource, params, authorizer)
        resource.assign_attributes normalize params
        ensure_attributes_for authorizer, action, resource
        resource.save if valid? resource
        resource
      rescue ::ActiveRecord::StatementInvalid, unknown_attribute_error => e
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

      # @return [String] param key
      def param_key
        @model_class.model_name.param_key
      end

      # @return [Array] the list of attributes to whitelist for mass assignment
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

      # @return [Class] ActiveModel::UnknownAttributeError if Rails 4
      # @return [Class] ActiveRecord::UnknownAttributeError if Rails 5
      def unknown_attribute_error
        (defined?(::ActiveModel::UnknownAttributeError) ? ::ActiveModel : ::ActiveRecord)::UnknownAttributeError
      end
    end
  end
end

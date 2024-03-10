# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # Model service provider for {Wallaby::ActiveRecord}
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # @param params [ActionController::Parameters]
      # @param action [String, Symbol]
      # @param authorizer
      # @return [ActionController::Parameters] allowlisted parameters
      def permit(params, action, authorizer)
        authorized_fields = authorizer.permit_params(action, @model_class)
        params.require(param_key).permit(authorized_fields || permitted_fields)
      end

      # @note Pagination free here. Since somewhere might need the collection without any pagination
      # @param params [ActionController::Parameters]
      # @param authorizer [Ability] for now
      # @return [ActiveRecord::Relation] relation
      def collection(params, authorizer)
        query = querier.search(params)
        query = querier.sort(params[:sort], query)
        authorizer.accessible_for(:index, query)
      end

      # @param query [ActiveRecord::Relation]
      # @param params [ActionController::Parameters]
      # @return [ActiveRecord::Relation] paginated query
      def paginate(query, params)
        per = (params[:per] || Wallaby.controller_configuration.try(:page_size)).to_i
        page = [params[:page].to_i, 1].max # starting from page 1
        query.offset((page - 1) * per).limit(per) # rubocop:disable CodeReuse/ActiveRecord
      end

      # @note No mass assignment happens here!
      # @return [Object] new resource object
      def new(_params, _authorizer)
        @model_class.new
      end

      # @note No mass assignment happens here!
      # Find the record using id.
      # @param id [Integer, String]
      # @return [Object] persisted resource object
      # @raise [Wallaby::ResourceNotFound] when record is not found
      def find(id, _params, _authorizer)
        @model_class.find(id)
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound, id
      end

      # Assign resource with new values and store it in database as new record.
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      # @param authorizer [Wallaby::ModelAuthorizer]
      def create(resource, params, authorizer)
        save(__callee__, resource, params, authorizer)
      end

      # Assign resource with new values and store it in database as an update.
      # @param resource [Object]
      # @param params [ActionController::Parameters]
      # @param authorizer [Wallaby::ModelAuthorizer]
      def update(resource, params, authorizer)
        save(__callee__, resource, params, authorizer)
      end

      # Remove a record from database
      # @param resource [Object]
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
        resource.assign_attributes(normalize(params))
        ensure_attributes_for(authorizer, action, resource)
        resource.save if valid?(resource)
        resource
      rescue ::ActiveRecord::ActiveRecordError, ActiveModel::ForbiddenAttributesError, unknown_attribute_error => e
        resource.errors.add(:base, e.message)
        resource
      end

      # Normalize params
      # @param params [ActionController::Parameters]
      def normalize(params)
        normalizer.normalize(params)
      end

      # See if a resource is valid
      # @param resource [Object]
      # @return [true] if valid
      # @return [false] otherwise
      def valid?(resource)
        validator.valid?(resource)
      end

      # To make sure that the record can be updated with the values that are
      # allowed to.
      # @param authorizer [Object]
      # @param action [String]
      # @param resource [Object]
      def ensure_attributes_for(authorizer, action, resource)
        return if authorizer.blank?

        restricted_conditions = authorizer.attributes_for(action, resource)
        resource.assign_attributes(restricted_conditions)
      end

      # @return [String] param key
      def param_key
        @model_class.model_name.param_key
      end

      # @return [Array] the list of attributes to allowlist for mass assignment
      def permitted_fields
        @permitted_fields ||=
          permitter.simple_field_names << permitter.compound_hashed_fields
      end

      # @return [Wallaby::ActiveRecord::ModelServiceProvider::Permitter]
      def permitter
        @permitter ||= Permitter.new(@model_decorator)
      end

      # @return [Wallaby::ActiveRecord::ModelServiceProvider::Querier]
      def querier
        @querier ||= Querier.new(@model_decorator)
      end

      # @return [Wallaby::ActiveRecord::ModelServiceProvider::Normalizer]
      def normalizer
        @normalizer ||= Normalizer.new(@model_decorator)
      end

      # @return [Wallaby::ActiveRecord::ModelServiceProvider::Validator]
      def validator
        @validator ||= Validator.new(@model_decorator)
      end

      # @return [Class] ActiveModel::UnknownAttributeError if Rails 4
      # @return [Class] ActiveRecord::UnknownAttributeError if Rails 5
      def unknown_attribute_error
        (defined?(::ActiveModel::UnknownAttributeError) ? ::ActiveModel : ::ActiveRecord)::UnknownAttributeError
      end
    end
  end
end

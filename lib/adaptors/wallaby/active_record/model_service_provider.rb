module Wallaby
  class ActiveRecord
    # Model operator
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      def permit(params)
        return {} if params[param_key].blank?
        params.require(param_key).permit permitted_fields
      end

      def collection(params, authorizer)
        # NOTE: pagination free here
        # since somewhere might use it without pagination
        query = querier.search params
        query = query.order params[:sort] if params[:sort].present?
        query.accessible_by authorizer
      end

      def paginate(query, params)
        per = params[:per] || Wallaby.configuration.page_size
        query = query.page params[:page] if query.respond_to? :page
        query = query.per per if query.respond_to? :per
        query
      end

      def new(permitted_params, _authorizer)
        @model_class.new normalize permitted_params
      rescue ::ActiveModel::UnknownAttributeError
        @model_class.new
      end

      def find(id, permitted_params, _authorizer)
        resource = @model_class.find id
        resource.assign_attributes normalize permitted_params
        resource
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound, id
      rescue ::ActiveModel::UnknownAttributeError
        resource
      end

      def create(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      def update(resource_with_new_value, params, authorizer)
        save __callee__, resource_with_new_value, params, authorizer
      end

      def destroy(resource, _params, _authorizer)
        resource.destroy
      end

      protected

      def save(action, resource, _params, authorizer)
        ensure_attributes_for authorizer, action, resource
        resource.save if valid? resource
        resource
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        resource
      end

      def normalize(params)
        normalizer.normalize params
      end

      def valid?(resource)
        validator.valid? resource
      end

      def ensure_attributes_for(authorizer, action, resource)
        return if authorizer.blank?
        restricted_conditions = authorizer.attributes_for action, resource
        resource.assign_attributes restricted_conditions
      end

      def param_key
        @model_class.model_name.param_key
      end

      def permitted_fields
        @permitted_fields ||=
          permitter.simple_field_names << permitter.compound_hashed_fields
      end

      def permitter
        @permitter ||= Permitter.new @model_decorator
      end

      def querier
        @querier ||= Querier.new @model_decorator
      end

      def normalizer
        @normalizer ||= Normalizer.new @model_decorator
      end

      def validator
        @validator ||= Validator.new @model_decorator
      end
    end
  end
end

module Wallaby
  class ActiveRecord
    # Model operator
    class ModelHandler < ::Wallaby::ModelHandler
      def collection(params, authorizer)
        per = params[:per] || Wallaby.configuration.page_size
        query = querier.search params
        query = query.order params[:sort] if params[:sort].present?
        query = query.page params[:page] if query.respond_to? :page
        query = query.per per if query.respond_to? :per
        query.accessible_by authorizer
      end

      def new(params, _authorizer)
        @model_class.new permit params
      rescue ::ActionController::ParameterMissing
        @model_class.new {}
      end

      def find(id, _params, _authorizer)
        @model_class.find id
      rescue ::ActiveRecord::RecordNotFound
        raise ResourceNotFound, id
      end

      def create(params, authorizer)
        resource = @model_class.new
        resource.assign_attributes normalize permit(params)
        ensure_attributes_for authorizer, :create, resource
        resource.save if valid? resource
        [resource, resource.errors.blank?]
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        [resource, false]
      end

      def update(resource, params, authorizer)
        resource.assign_attributes normalize permit(params)
        ensure_attributes_for authorizer, :update, resource
        resource.save if valid? resource
        [resource, resource.errors.blank?]
      rescue ::ActiveRecord::StatementInvalid => e
        resource.errors.add :base, e.message
        [resource, false]
      end

      def destroy(resource, _params, _authorizer)
        resource.destroy
      end

      protected

      def permit(params)
        fields =
          permitter.simple_field_names << permitter.compound_hashed_fields
        params.require(param_key).permit(fields)
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

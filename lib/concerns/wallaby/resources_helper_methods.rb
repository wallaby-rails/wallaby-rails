module Wallaby
  # This is a collection of the helper methods used in controller and helper
  module ResourcesHelperMethods
    extend ActiveSupport::Concern

    protected

    # Shorthand of params[:id]
    # @return [String, nil] ID param
    def resource_id
      params[:id]
    end

    # @return [#each] a collection of all the records
    def collection
      @collection ||= paginate current_model_service.collection params
    end

    # @return [Object] either persisted or unpersisted resource instance
    def resource
      @resource ||= begin
        # white-listed params
        whitelisted = action_name.in?(SAVE_ACTIONS) ? resource_params : {}
        if resource_id.present?
          current_model_service.find resource_id, whitelisted
        else
          current_model_service.new whitelisted
        end
      end
    end

    # @return [Wallaby::ModelDecorator, nil] current model decorator
    def current_model_decorator
      @current_model_decorator ||= helpers.model_decorator current_model_class
    end

    # A wrapper method for authorizer
    # @return [Ability]
    def authorizer
      # current_ability
      @authorizer ||= helpers.model_authorizer(current_model_class).new(self, current_model_class)
    end
  end
end

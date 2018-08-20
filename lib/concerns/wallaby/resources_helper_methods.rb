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
      @collection ||= paginate current_model_servicer.collection params
    end

    # @return [Object] either persisted or unpersisted resource instance
    def resource
      @resource ||= begin
        # white-listed params
        whitelisted = action_name.in?(SAVE_ACTIONS) ? resource_params : {}
        if resource_id.present?
          current_model_servicer.find resource_id, whitelisted
        else
          current_model_servicer.new whitelisted
        end
      end
    end
  end
end

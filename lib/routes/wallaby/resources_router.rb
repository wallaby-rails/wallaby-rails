module Wallaby
  # @private
  # This is the core of wallaby that dynamically dispatches request to
  # appropriate controller and action.
  class ResourcesRouter
    # @see http://edgeguides.rubyonrails.org/routing.html#routing-to-rack-applications
    # It tries to find out the controller that has the same model class from
    # converted resources name. Otherwise, it falls back to generic controller
    # `Wallaby::ResourcesController`.
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def call(env)
      params = env[ActionDispatch::Http::Parameters::PARAMETERS_KEY]
      controller = find_controller_by params[:resources]
      params[:action] = find_action_by params

      controller.action(params[:action]).call env
    rescue ::AbstractController::ActionNotFound, ModelNotFound => e
      params[:error] = e
      ResourcesController.action(:not_found).call env
    end

    private

    def find_controller_by(resources_name)
      model_class = Map.model_class_map resources_name
      Map.controller_map model_class
    end

    def find_action_by(params)
      # Action name comes from either the defaults or :action param
      # @see Wallaby::Engine.routes
      (params.delete(:defaults) || params)[:action]
    end
  end
end

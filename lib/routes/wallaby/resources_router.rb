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
      controller = find_controller_by(params[:resources]) || default_controller
      params[:action] = find_action_by params

      controller.action(params[:action]).call env
    rescue ::AbstractController::ActionNotFound, ModelNotFound => e
      params[:error] = e
      default_controller.action(:not_found).call env
    end

    private

    # @param resources_name [String] resource name in plural
    # @return [Class] controller class
    def find_controller_by(resources_name)
      model_class = Map.model_class_map resources_name
      Map.controller_map model_class
    end

    # @param params [ActionController::Parameters]
    # @return [String, Symbol] action name
    def find_action_by(params)
      # Action name comes from either the defaults or :action param
      # @see Wallaby::Engine.routes
      (params.delete(:defaults) || params)[:action]
    end

    # TODO: change to reflect the mount path changes
    # @return [Class] controller class from configuration
    def default_controller
      Wallaby.configuration.mapping.resources_controller
    end
  end
end

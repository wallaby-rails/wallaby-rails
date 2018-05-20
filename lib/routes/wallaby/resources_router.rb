module Wallaby
  # @private
  # This is the core of wallaby that dynamically dispatches request to
  # appropriate controller and action.
  class ResourcesRouter
    # @see http://edgeguides.rubyonrails.org/routing.html#routing-to-rack-applications
    # It tries to find out the controller that has the same model class from converted resources name. Otherwise,
    # it falls back to generic resources controller `Admin::ApplicationController` or `Wallaby::ResourcesController`.
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def call(env)
      params = env[ActionDispatch::Http::Parameters::PARAMETERS_KEY]
      controller = find_controller_by params
      controller.action(params[:action]).call env
    rescue ::AbstractController::ActionNotFound, ModelNotFound => e
      params[:error] = e
      default_controller(params).action(:not_found).call env
    end

    private

    # @param params [ActionController::Parameters]
    # @return [Class] controller class
    def find_controller_by(params)
      model_class = Map.model_class_map params[:resources]
      Map.controller_map model_class, params[:resources_controller]
    end

    # @param params [ActionController::Parameters]
    # @return [Class] controller class from engine mounting or global configuration
    def default_controller(params)
      params[:resources_controller] || Wallaby.configuration.mapping.resources_controller
    end
  end
end

module Wallaby
  # @private
  # This is the core of wallaby that dynamically dispatches request to appropriate controller and action.
  class ResourcesRouter
    # @see http://edgeguides.rubyonrails.org/routing.html#routing-to-rack-applications
    # It tries to find out the controller that has the same model class from converted resources name.
    # Otherwise, it falls back to base resources controller which will come from the following sources:
    # 1. `:resources_controller` parameter
    # 2. resources_controller mapping configuration,
    #   e.g. `Admin::ApplicationController` if defined or `Wallaby::ResourcesController`
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def call(env)
      params = env[ActionDispatch::Http::Parameters::PARAMETERS_KEY]
      controller = find_controller_by params
      controller.action(params[:action]).call env
    rescue ::AbstractController::ActionNotFound, ModelNotFound, UnprocessableEntity => exception
      set_message_for exception, env
      default_controller(params).action(:not_found).call env
    end

    private

    # Find the controller class by model class
    # @param params [ActionController::Parameters]
    # @return [Class] controller class
    def find_controller_by(params)
      model_class = Map.model_class_map params[:resources]
      supported? model_class
      Map.controller_map(model_class, params[:resources_controller]) || default_controller(params)
    end

    # The controller class sources from engine mounting parameter or global configuration
    # @param params [ActionController::Parameters]
    # @return [Class] controller class
    def default_controller(params)
      params[:resources_controller] || Wallaby.configuration.mapping.resources_controller
    end

    # Check and see if the model is supported or not
    # @param model_class [Class]
    def supported?(model_class)
      return if model_class && Map.mode_map[model_class]
      raise UnprocessableEntity, I18n.t('errors.unprocessable_entity.model', model: model_class)
    end

    # Set flash error message
    # @param exception [Exception]
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def set_message_for(exception, env)
      session = env[ActionDispatch::Request::Session::ENV_SESSION_KEY] || {}
      flash = env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.from_session_value session['flash']
      flash['error'] = exception.message
    end
  end
end

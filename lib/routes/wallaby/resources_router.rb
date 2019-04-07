module Wallaby
  # This is the core of wallaby that dynamically dispatches request to appropriate controller and action.
  class ResourcesRouter
    # @see http://edgeguides.rubyonrails.org/routing.html#routing-to-rack-applications
    # It tries to find out the controller that has the same model class from converted resources name.
    # Otherwise, it falls back to base resources controller which will come from the following sources:
    #
    # 1. `:resources_controller` parameter
    # 2. resources_controller mapping configuration,
    #   e.g. `Admin::ApplicationController` if defined or `Wallaby::ResourcesController`
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def call(env)
      params = env[ActionDispatch::Http::Parameters::PARAMETERS_KEY]
      controller = find_controller_by params
      controller.action(params[:action]).call env
    rescue ::AbstractController::ActionNotFound, ModelNotFound => e
      set_message_for e, env
      default_controller(params).action(:not_found).call env
    rescue UnprocessableEntity => e
      set_message_for e, env
      default_controller(params).action(:unprocessable_entity).call env
    end

    private

    # Find controller class
    # @param params [Hash]
    # @return [Class] controller class
    def find_controller_by(params)
      model_class = find_model_class_by params
      Map.controller_map(model_class, params[:resources_controller]) || default_controller(params)
    end

    # Default controller class sources from:
    #
    # 1. `:resources_controller` parameter
    # 2. resources_controller mapping configuration,
    # @param params [Hash]
    # @return [Class] controller class
    def default_controller(params)
      params[:resources_controller] || Wallaby.configuration.mapping.resources_controller
    end

    # Find out the model class
    # @param params [Hash]
    # @return [Class]
    # @raise [Wallaby::ModelNotFound] when model class is not found
    # @raise [Wallaby::UnprocessableEntity] when there is no corresponding mode found for model class
    def find_model_class_by(params)
      model_class = Map.model_class_map params[:resources]
      return model_class unless MODEL_ACTIONS.include? params[:action].to_sym
      raise ModelNotFound, params[:resources] unless model_class
      unless Map.mode_map[model_class]
        raise UnprocessableEntity, I18n.t('errors.unprocessable_entity.model', model: model_class)
      end
      model_class
    end

    # Set flash error message
    # @param exception [Exception]
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def set_message_for(exception, env)
      session = env[ActionDispatch::Request::Session::ENV_SESSION_KEY] || {}
      env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.from_session_value session['flash']
      flash = env[ActionDispatch::Flash::KEY]
      flash[:alert] = exception.message
    end
  end
end

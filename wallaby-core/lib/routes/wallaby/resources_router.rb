# frozen_string_literal: true

module Wallaby
  # This is the core of {Wallaby} as it dynamically dispatches request to appropriate controller and action.
  #
  # Assume that:
  #
  # - {Wallaby} is mounted at `/admin`
  # - current request path is `/admin/order::items`, then the resources name is `order::items`
  #
  # {ResourcesRouter} will try to find out which controller to dispatch to by:
  #
  # - check if the controller name `Admin::Order::ItemsController` exists
  #   (converted from the mount path and resources name)
  # - check if the `:resources_controller` defaults is set when mounting {Wallaby}, for example:
  #
  #   ```
  #   wallaby_mount at: '/admin', defaults: { resources_controller: CoreController }
  #   ```
  #
  # - fall back to default resources controller from
  #   {Configuration#resources_controller Wallaby.configuration.resources_controller}
  # @see http://edgeguides.rubyonrails.org/routing.html#routing-to-rack-applications
  class ResourcesRouter
    # It dispatches the request to corresponding controller and action.
    # @param env [Hash] (see https://github.com/rack/rack/blob/master/SPEC.rdoc)
    # @return [void]
    def call(env)
      options = get_options_from(env)
      validate_model_by(options[:resources])
      controller_class = find_controller_class_by(options)
      controller_class.action(options[:action]).call(env)
    rescue ::AbstractController::ActionNotFound, ModelNotFound => e
      set_flash_error_for(e, env)
      default_controller(options).action(:not_found).call(env)
    rescue UnprocessableEntity => e
      set_flash_error_for(e, env)
      default_controller(options).action(:unprocessable_entity).call(env)
    end

    protected

    # @param env [Hash] (see https://github.com/rack/rack/blob/master/SPEC.rdoc)
    # @return [Hash] options, which contains params and script name
    def get_options_from(env)
      env[ActionDispatch::Http::Parameters::PARAMETERS_KEY].merge(
        script_name: env[SCRIPT_NAME]
      )
    end

    # Assume that:
    #
    # - {Wallaby} is mounted at `/admin`
    # - current request path is `/admin/order::items`, then the resources name is `order::items`
    #
    # Then it expects to return the first controller from the following list:
    #
    # - Admin::Order::ItemsController
    # - `:resources_controller` defaults
    # - default controller set by
    #   {Configuration#resources_controller Wallaby.configuration.resources_controller}
    # @param options [Hash]
    # @return [Class] controller class
    def find_controller_class_by(options)
      return default_controller(options) unless options[:resources]

      Classifier.to_class(
        Inflector.to_controller_name(options[:script_name], options[:resources])
      ) do |controller_name|
        Logger.hint(
          :customize_controller,
          <<~INSTRUCTION
            HINT: To customize the controller for resources `#{options[:resources]}`,
            create the following controller:

              class #{controller_name} < #{default_controller(options)}
                def #{options[:action]}
                  # it's possible to re-use what's implemented by calling `#{options[:action]}!`
                  # or `super` if bang version does not exist
                  #{options[:action]}!
                end
              end
          INSTRUCTION
        )

        default_controller(options)
      end
    end

    # @param options [Hash]
    # @return [Class] default controller class
    def default_controller(options)
      options[:resources_controller] || Wallaby.configuration.resources_controller
    end

    # @param resources_name [String]
    # @raise [ModelNotFound] when model class can not be not found
    # @raise [UnprocessableEntity]
    #   when there is no corresponding {Mode} found for model class
    #   (which means {Wallaby})
    # @return [void]
    def validate_model_by(resources_name)
      return unless resources_name # maybe it's for landing page or error page

      # now this is for our lovely resourceful actions
      model_name = Inflector.to_model_name(resources_name)
      model_class = Classifier.to_class(model_name)
      raise ModelNotFound, model_name unless model_class
      return if Map.mode_map[model_class]

      Wallaby::Logger.warn <<~MESSAGE
        Cannot find the mode for #{model_name} and don't know how to handle it.
      MESSAGE
      raise UnprocessableEntity, Locale.t('errors.unprocessable_entity.model', model: model_class)
    end

    # @param exception [Exception]
    # @param env [Hash] (see https://github.com/rack/rack/blob/master/SPEC.rdoc)
    # @return [void]
    def set_flash_error_for(exception, env)
      session = env[ActionDispatch::Request::Session::ENV_SESSION_KEY] || {}
      env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.from_session_value session['flash']
      flash = env[ActionDispatch::Flash::KEY]
      flash[:alert] = exception.message
    end
  end
end

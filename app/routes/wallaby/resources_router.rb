module Wallaby
  class ResourcesRouter
    def call env
      controller  = find_controller env
      action      = find_action env
      controller.action(action).call env
    rescue AbstractController::ActionNotFound
      controller.action(:not_found).call env
    end

    def find_controller env
      controller_list(env).find do |class_name|
        Object.const_defined? class_name
      end.try(:constantize) or Wallaby::ResourcesController
    end

    def find_action env
      params(env)[:action]
    end

    protected
    def controller_list env
      resources = normalize_resources_name env
      namespace = normalize_namespace env
      [
        [ namespace, resources ],
        [ 'wallaby', resources ],
      ].map do |namespace, controller_name|
        "#{ namespace }/#{ controller_name }_controller".camelize
      end
    end

    def params env
      env['action_dispatch.request.path_parameters']
    end

    def normalize_resources_name env
      params(env)[:resources].gsub '::', '/'
    end

    def normalize_namespace env
      env['SCRIPT_NAME']
    end
  end
end
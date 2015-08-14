class Wallaby::ResourcesRouter
  def call env
    target_controller = find_controller env
    target_action     = params(env)[:action]
    target_controller.action(target_action).call env
  rescue AbstractController::ActionNotFound
    target_controller.action(:not_found).call env
  end

  protected
  def find_controller env
    resources_name = params(env)[:resources]
    Wallaby::ResourcesController.subclasses.find do |klass|
      klass.resources_name == resources_name
    end or Wallaby::ResourcesController
  end

  def params env
    env['action_dispatch.request.path_parameters']
  end
end

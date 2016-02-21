if Rails.env.development?
  # NOTE: Rails reload! will hit here
  Rails.cache.clear

  # NOTE: we search for subclasses of Wallaby::ResourcesController and Wallaby::ResourceDecorator.
  # therefore, under development environment, we need to preload all classes under /app folder in main_app
  # using `require` is not working for preloading, we need to classify the class names to make Rails reload classes properly
  Wallaby::ApplicationController

  Dir[ 'app/**/*.rb' ].each do |file_path|
    name = file_path[ %r(app/[^/]+/(.+)\.rb), 1 ]
    name.classify.constantize
  end
end

class Wallaby::ResourcesRouter
  DEFAULT_CONTROLLER = Wallaby::ResourcesController

  def call(env)
    params            = env['action_dispatch.request.path_parameters']
    target_controller = find_controller_by params[:resources]
    target_action     = params[:action]
    target_controller.action(target_action).call env
  rescue AbstractController::ActionNotFound
    target_controller.action(:not_found).call env
  end

  protected
  def cached_subclasses
    Rails.cache.fetch 'wallaby/resources_router' do
      DEFAULT_CONTROLLER.subclasses.reject do |klass|
        klass.name.blank?
      end
    end
  end

  def find_controller_by(resources_name)
    cached_subclasses.find do |klass|
      klass.resources_name == resources_name
    end or DEFAULT_CONTROLLER
  end
end

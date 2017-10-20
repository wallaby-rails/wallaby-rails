module Wallaby
  # Responsible to dispatch requests to controller and action
  class ResourcesRouter
    def call(env)
      params = env['action_dispatch.request.path_parameters']
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
      (params.delete(:defaults) || params)[:action]
    end
  end
end

if Rails.env.development?
  # NOTE: Rails reload! will hit here
  puts <<-DEBUG
  [ WALLABY ] reload! triggered
    1. Start GC
    2. Clear all the maps
    3. Re-preload all files under folder `app`
  DEBUG
  GC.start
  Wallaby::Map.clear

  # NOTE: we search for subclasses of
  # Wallaby::ResourcesController and Wallaby::ResourceDecorator.
  # therefore, under development environment, we need to preload
  # all classes under /app folder in main_app
  # using `require` is not working for preloading, we need to constantize
  # the class names to make Rails reload classes properly
  Wallaby::ApplicationController.to_s

  preload = proc do |file_pattern|
    Dir[file_pattern].each do |file_path|
      begin
        name = file_path[%r{app/[^/]+/(.+)\.rb}, 1].gsub('concerns/', '')
        name.classify.constantize
      rescue NameError, LoadError => e
        puts ">>>>>>>>> PRELOAD ERROR: #{e.message}"
        puts e.backtrace.slice(0, 5)
      end
    end
  end

  preload.call 'app/models/**.rb'
  preload.call 'app/**/*.rb'
end

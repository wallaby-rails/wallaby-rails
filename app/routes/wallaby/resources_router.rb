module Wallaby
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

# NOTE: please keep this block at the end.
# otherwise, it might go into a endless reloading loop in dev environment
if Rails.env.development?
  # NOTE: Rails reload! will hit here
  puts <<-DEBUG
  [ WALLABY ] reload! triggered
    1. Clear all the maps
    2. Clear tmp folder
    3. Re-preload all files under folder `app`
  DEBUG
  Wallaby::Map.clear
  FileUtils.rm_rf Dir['tmp/cache/[^.]*'], verbose: false

  # NOTE: we search for subclasses of
  # Wallaby::ResourcesController and Wallaby::ResourceDecorator.
  # therefore, under development environment, we need to preload
  # all classes under /app folder in main_app
  # using `require` is not the way how Rails loads a class,
  # we need to constantize the class names instead
  # @see http://guides.rubyonrails.org/autoloading_and_reloading_constants.html
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

module Wallaby
  # @!visibility private
  # Url helper
  class UrlFor
    class << self
      ACTION_PATH_MAP =
        Wallaby::ERRORS.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |error, map|
          map[error] = :"#{error}_path"
        end.merge(
          healthy: :root_path,
          home: :root_path,
          index: :resources_path,
          create: :resources_path,
          show: :resource_path,
          update: :resource_path,
          destroy: :resource_path,
          new: :new_resource_path,
          edit: :edit_resource_path
        ).freeze
      # Handle wallaby engine url properly.
      # @param engine [ActionDispatch::Routing::RoutesProxy]
      # @param options [ActionController::Parameters, Hash]
      # @return [String] url string for wallaby engine
      def handle(engine, engine_name, options)
        # NOTE: DEPRECATION WARNING: You are calling a `*_path` helper with the
        # `only_path` option explicitly set to `false`.
        # This option will stop working on path helpers in Rails 5.
        # Use the corresponding `*_url` helper instead.
        hash = normalize_params(engine_name, options).except(:only_path)
        path_method = ACTION_PATH_MAP[hash[:action]]
        engine.public_send path_method, hash if path_method
      end

      private

      # Please note that url helper is not very friendly with parameters,
      # therefore, it is needed to convert the parameters into hash.
      #
      # Plus `script_name` needs to be set so that the engine url can be generated with the correct script name.
      # @param options [ActionController::Parameters, Hash]
      # @return [Hash]
      def normalize_params(engine_name, options)
        hash = options.is_a?(ActionController::Parameters) ? options.permit(:resources, :action, :id).to_h : options
        # current engine's script name
        hash[:script_name] ||= Rails.application.routes.named_routes[engine_name].path.spec.to_s
        hash
      end
    end
  end
end

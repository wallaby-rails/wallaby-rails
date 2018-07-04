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
      def handle(engine, options)
        # NOTE: DEPRECATION WARNING: You are calling a `*_path` helper with the
        # `only_path` option explicitly set to `false`.
        # This option will stop working on path helpers in Rails 5.
        # Use the corresponding `*_url` helper instead.
        hash = normalize_params(options).except(:only_path)
        path_method = ACTION_PATH_MAP[hash[:action]]
        engine.public_send path_method, hash if path_method
      end

      private

      # We will need to normalize params and return a hash
      # so that the url helper
      # could build up the url properly.
      # @param options [ActionController::Parameters, Hash]
      # @return [Hash]
      def normalize_params(options)
        return options unless options.is_a? ActionController::Parameters
        options.permit(:resources, :action, :id).to_h
      end
    end
  end
end

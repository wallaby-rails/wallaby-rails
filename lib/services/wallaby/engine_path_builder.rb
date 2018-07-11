module Wallaby
  # Url builder for wallaby engine
  class EnginePathBuilder
    class << self
      # A constant to map actions to their paths.
      ACTION_TO_PATH_MAP =
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

      # Generate url that wallaby engine supports (home/resourceful/errors).
      # @param engine [ActionDispatch::Routing::RoutesProxy]
      # @param engine_name [String] engine name
      # @param parameters [ActionController::Parameters, Hash]
      # @return [String] path string for wallaby engine
      # @return [nil] nil if this builder doesn't know how to handle the parameters
      def handle(engine, engine_name, parameters)
        # NOTE: DEPRECATION WARNING: You are calling a `*_path` helper with the
        # `only_path` option explicitly set to `false`.
        # This option will stop working on path helpers in Rails 5.
        # Use the corresponding `*_url` helper instead.
        hash = normalize(parameters, engine_name).except(:only_path)
        path_method = ACTION_TO_PATH_MAP[hash[:action]]
        engine.public_send path_method, hash if path_method
      end

      private

      # @see wallaby/spec/active_support/url_helper_spec.rb
      # Please note that URL helper is not working well with parameters in Rails 5.0.*,
      # therefore, parameters has to be converted into hash.
      #
      # And in Rails version 5.0 and below, if an engine is mounted multiple times,
      # and `script_name` param is not provided, engine URL helper will generate a URL with wrong script name.
      #
      # e.g. if `wallaby_engine` is mounted to `/admin` and `/inner`,
      # `wallaby_engine.resources_path resources: 'products'` will generate a URL `/inner/products`,
      # but `/admin/products` is expected.
      #
      # Therefore, in this implementation, it will add `script_name` to the hash to pass to engine url helper method.
      # @param parameters [ActionController::Parameters, Hash]
      # @param engine_name [String] engine name that can be found in named routes
      # @return [Hash] a hash ready to use by engine url helper
      def normalize(parameters, engine_name)
        hash =
          if parameters.is_a? ActionController::Parameters
            parameters.permit(:resources, :action, :id).to_h.with_indifferent_access
          else
            parameters
          end
        # set script name for given engine
        hash[:script_name] ||= Rails.application.routes.named_routes[engine_name].path.spec.to_s
        hash
      end
    end
  end
end

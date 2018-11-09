module Wallaby
  # Url builder for Wallaby engine
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

      # Generate URL that Wallaby engine supports (home/resourceful/errors)
      # (see {https://github.com/reinteractive/wallaby/blob/master/config/routes.rb config/routes.rb}).
      # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb config/routes.rb
      # @param engine_name [String] engine name
      # @param parameters [ActionController::Parameters, Hash]
      # @param default_url_options [Hash]
      # @return [String] path string for wallaby engine
      # @return [nil] nil if this builder doesn't know how to handle the parameters
      def handle(engine_name:, parameters:, default_url_options: {})
        route = Rails.application.routes.named_routes[engine_name]
        return unless route

        hash = normalize parameters, default_url_options, route
        path_method = ACTION_TO_PATH_MAP[hash[:action]]
        Wallaby::Engine.routes.url_helpers.public_send path_method, hash if path_method
      end

      private

      # @see https://github.com/reinteractive/wallaby/blob/master/spec/active_support/url_helper_spec.rb
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
      # Therefore, in this implementation, it will add `script_name` to the hash to pass to engine URL helper method.
      # @param parameters [ActionController::Parameters, Hash]
      # @param default_url_options [Hash]
      # @param route [ActionDispatch::Journey::Route]
      # @return [Hash] a hash ready to use by engine URL helper
      def normalize(parameters, default_url_options, route)
        default_url_options
          .with_indifferent_access
          .merge(Utils.try_to(parameters, :permit, :resources, :action, :id) || parameters)
          .merge(script_name: route.path.spec.to_s) # set script name for given engine
          .except(:only_path).symbolize_keys
      end
    end
  end
end

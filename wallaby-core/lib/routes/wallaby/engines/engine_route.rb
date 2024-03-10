# frozen_string_literal: true

module Wallaby
  module Engines
    # The general route of {Engine} looks like as follow:
    #
    #     /admin/order::items
    #
    # Therefore, to override this route, dev needs to define a resources as below
    # before mounting {Engine}:
    #
    #     namespace :admin do
    #       # NOTE: in order for the route to work properly,
    #       # the colon before words need to be escaped in the path option
    #       resources :items, path: 'order:\:item', module: :order
    #     end
    #     wallaby_mount at: '/admin'
    #
    # So to find out if any route has been overriden with current request, e.g. `/admin/order::items/1/edit`,
    # we will look into the following conditions:
    #
    # - begins with `/admin`
    # - same **action** as the given **action**
    # - default **controller** exists (as {ResourcesRouter} does not define static **controller**)
    #
    # Then we use this route's params and pass it to the origin `url_for`.
    class EngineRoute < BaseRoute
      # A constant to map actions to its corresponding path helper methods
      # defined in {Engine}'s routes.
      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb
      ACTION_TO_URL_HELPER_MAP =
        Wallaby::ERRORS.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |error, map|
          map[error] = :"#{error}_path"
        end.merge(
          home: :root_path,
          # for resourceful actions
          index: :resources_path,
          new: :new_resource_path,
          show: :resource_path,
          edit: :edit_resource_path
        ).freeze

      def url
        # NOTE: require to use `url_helper` here.
        # otherwise, {Engine} will raise **ActionController::UrlGenerationError**.
        engine_params = params_for(route)
        Engine.routes.url_helpers.try(engine_action_url_helper, engine_params)
      end

      protected

      # @return [ActionDispatch::Journey::Route]
      #   the application route that overrides the route handled by {Engine}
      def route
        @route ||=
          Engine.routes.routes.find do |route|
            route.requirements[:action] == action_name
          end
      end

      # @return [Symbol] the URL helper for given action
      def engine_action_url_helper
        ACTION_TO_URL_HELPER_MAP[action_name.try(:to_sym)]
      end

      # @return [Hash]
      def complete_params
        @complete_params ||=
          normalize_params(
            { script_name: context.script_name },
            with_query_params,
            params
          )
      end
    end
  end
end

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
    class CustomAppRoute < BaseRoute
      # @return [true] if the route matches the condition exists
      # @return [false] otherwise
      def exist?
        route.present?
      end

      def url
        context.url_for(params_for(route), super: true)
      end

      protected

      delegate :script_name, to: :context

      # @return [ActionDispatch::Journey::Route]
      #   the application route that overrides the route handled by {Engine}
      def route
        @route ||=
          Rails.application.routes.routes.find do |route|
            prefix_matched?(route) && requirements_matched?(route)
          end
      end

      # @return [true] if route's path begins with the prefix as where {Engine} route to,
      #   e.g. `/admin/order::items`
      # @return [false] otherwise
      def prefix_matched?(route)
        path = route.path.spec.to_s
        path == script_name || path.start_with?(script_name + SLASH)
      end

      # @return [true] if the params matches route's requirements
      # @return [false] otherwise
      def requirements_matched?(route)
        return false if route.requirements.blank?

        route_params =
          params_for(route).tap do |params|
            params[:controller] = same_controller? ? context.controller_path : possible_controller_path
          end

        route.requirements <= route_params
      end

      # @return [true] if the given params is under the same controller as current request
      # @return [false] otherwise
      def same_controller?
        context.current_model_class == model_class || context.current_resources_name == resources_name
      end

      # @return [String] possible controller path
      def possible_controller_path
        "#{script_name}/#{resources_name}"
      end

      # @return [Hash]
      def complete_params
        @complete_params ||=
          normalize_params(with_query_params, params).tap do |normalized_params|
            normalized_params.delete(:resources) if same_controller?
          end
      end
    end
  end
end

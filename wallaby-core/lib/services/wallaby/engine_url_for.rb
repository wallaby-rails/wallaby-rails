# frozen_string_literal: true

module Wallaby
  # URL service object for {Urlable#url_for} helper
  #
  # Since {Engine}'s {https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb routes}
  # are declared in
  # {https://guides.rubyonrails.org/routing.html#routing-to-rack-applications Rack application}
  # fashion via {ResourcesRouter} to recoganize path in the pattern of `/:mount_path/:resources`.
  # It means when the current request path (e.g. `/admin/categories`)
  # is under the same mount path of {Engine} (e.g. `/admin`),
  # using the original Rails **usl_for** (e.g. `url_for action: :index`)
  # without providing the `:resources` param and script name
  # will lead to an **ActionController::RoutingError** exception.
  #
  # To generate the proper URL from given params and options for this kind of requests,
  # there are three kinds of scenarios that need to be considered
  # (assume that {Engine} is mounted at `/admin`):
  #
  # - if the URL to generate is a regular route defined before mounting the {Engine}
  #   that does not override the resources `categories` routes handled by {Engine}, such as:
  #
  #       namespace :admin do
  #         resources :custom_categories
  #       end
  #       wallaby_mount at: '/admin'
  #
  # - if the URL to generate is a route that overrides the existing {Engine} route
  #   (assume that `categories` is one of the resources handled by {Engine}):
  #
  #       namespace :admin do
  #         resources :categories
  #       end
  #       wallaby_mount at: '/admin'
  #
  # - regular resources handled by {ResourcesRouter}, e.g. (`/admin/products`)
  class EngineUrlFor
    include ActiveModel::Model

    # @!attribute context
    # @return [ActionController::Base, ActionView::Base]
    attr_accessor :context
    # @!attribute options
    # @return [Hash]
    attr_accessor :options
    # @!attribute params
    # @return [Hash, ActionController::Parameters]
    attr_accessor :params

    # Generate the proper URL depending on the context
    # @param context [ActionController::Base, ActionView::Base]
    # @param params [Hash, ActionController::Parameters]
    # @param options [Hash]
    # @option model_class [Class]
    # @option with_query [true] indicate if all query params should be included
    # @return [nil] nil if params is not a **Hash** or **ActionController::Parameters**
    # @see #execute
    def self.execute(context:, params:, options:)
      return unless params.is_a?(Hash) || params.try(:permitted?)

      new(context: context, params: params, options: options).execute
    end

    # @return [String] URL
    # @return [nil] nil if current request is not under any mounted {Engine}
    # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb
    def execute
      return if context.current_engine_route.blank?
      return custom_app_route.url if custom_app_route.exist?

      engine_route.url
    end

    private

    # @return [Wallaby::Engines::CustomAppRoute]
    def custom_app_route
      @custom_app_route ||=
        Engines::CustomAppRoute.new(
          context: context, params: params, options: options
        )
    end

    # @return [Wallaby::Engines::EngineRoute]
    def engine_route
      Engines::EngineRoute.new(
        context: context, params: params, options: options
      )
    end
  end
end

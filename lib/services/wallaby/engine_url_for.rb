module Wallaby
  # {Wallaby::ApplicationHelper#url_for} helper for Wallaby engine
  class EngineUrlFor
    # A constant to map actions to their route paths defined in Wallaby routes.
    ACTION_TO_PATH_MAP =
      Wallaby::ERRORS.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |error, map|
        map[error] = :"#{error}_path"
      end.merge(
        home: :root_path,
        index: :resources_path,
        new: :new_resource_path,
        show: :resource_path,
        edit: :edit_resource_path
      ).freeze

    class << self
      # Generate URL that Wallaby engine supports (e.g. home/resourceful/errors)
      # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb config/routes.rb
      # @param engine_name [string]
      # @param parameters [ActionController::Parameters, Hash]
      # @return [String] path string for wallaby engine
      # @return [nil] nil if given engine name cannot be found
      def handle(engine_name:, parameters:)
        route = Rails.application.routes.named_routes[engine_name]
        return unless route

        params = { script_name: route.path.spec.to_s }.merge(parameters).symbolize_keys

        ModuleUtils.try_to(
          Engine.routes.url_helpers, action_path_from(params), params
        )
      end

      protected

      # Find out the named path from given params
      # @return [Symbol] named path
      def action_path_from(params)
        action = params[:action] || params.fetch(:_recall, {})[:action]
        ACTION_TO_PATH_MAP[action]
      end
    end
  end
end

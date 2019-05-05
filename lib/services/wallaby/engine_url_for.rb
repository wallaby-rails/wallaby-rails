module Wallaby
  # `url_for` helper for Wallaby engine
  class EngineUrlFor
    # A constant to map actions to their route paths defined in Wallaby routes.
    ACTION_TO_PATH_MAP =
      Wallaby::ERRORS.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |error, map|
        map[error] = :"#{error}_path"
      end.merge(
        home: :root_path,
        index: :resources_path,
        create: :resources_path,
        show: :resource_path,
        update: :resource_path,
        destroy: :resource_path,
        new: :new_resource_path,
        edit: :edit_resource_path
      ).freeze

    # Generate URL that Wallaby engine supports (e.g. home/resourceful/errors)
    # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb config/routes.rb
    # @param engine [ActionDispatch::Routing::RoutesProxy, nil]
    # @param parameters [ActionController::Parameters, Hash]
    # @param script_name [String]
    # @return [String] path string for wallaby engine
    # @return [nil] nil if given engine is nil
    def self.handle(engine:, parameters:, script_name:)
      return unless engine

      options =
        engine
        .url_options.except(:_recall).with_indifferent_access
        .merge(engine.url_options[:_recall] || {})
        .merge(engine.default_url_options)
        .merge(script_name: script_name).merge(parameters.to_h)
      path_method = ACTION_TO_PATH_MAP[options[:action]]
      ModuleUtils.try_to engine, path_method, options
    end
  end
end

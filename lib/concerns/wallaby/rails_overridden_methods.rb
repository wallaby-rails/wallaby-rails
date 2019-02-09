module Wallaby
  # This is a collection of the helper methods that overrides the rails methods
  module RailsOverriddenMethods
    protected

    # Override {https://github.com/rails/rails/blob/master/actionview/lib/action_view/view_paths.rb
    # ActionView::ViewPaths::ClassMethods#_prefixes} to extend the prefixes for **ActionView::ViewPaths** to look up
    # in below precedence from high to low:
    #
    # - :mounted_path/:resources_name/:action_name (e.g. `admin/products/index`)
    # - :mounted_path/:resources_name (e.g. `admin/products`)
    # - :controller_path/:action_name
    # - :controller_path
    # - :parent_controller_path/:action_name
    # - :parent_controller_path
    # - :more_parent_controller_path/:action_name
    # - :more_parent_controller_path
    # - :wallaby_resources_controller_path/:action_name (e.g. `wallaby/resources/index`)
    # - :wallaby_resources_controller_path (e.g. `wallaby/resources`)
    # @return [Array<String>]
    def _prefixes
      @_prefixes ||= PrefixesBuilder.build( # rubocop:disable Naming/MemoizedInstanceVariableName
        origin_prefixes: super,
        theme_name: current_theme_name,
        resources_name: current_resources_name,
        script_name: request.env[SCRIPT_NAME],
        action_name: params[:action]
      )
    end
  end
end

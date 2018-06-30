module Wallaby
  # This is a collection of the helper methods that overrides the rails methods
  module RailsOverridenMethods
    extend ActiveSupport::Concern

    protected

    # Override origin ActionView::ViewPaths::ClassMethods#_prefixes
    # to add more paths so that it could look up partials in the following
    # order:
    # - mounted_path/resources_name/action_name (e.g. `admin/products/index)
    # - mounted_path/resources_name (e.g. `admin/products)
    # - full_path_of_custom_resources_controller/action_name
    #  (e.g. `management/custom_products/index)
    # - full_path_of_custom_resources_controller
    #  (e.g. `management/custom_products)
    # - wallaby_resources_controller_name/action_name
    #  (e.g. `wallaby/resources/index)
    # - wallaby_resources_controller_name
    #  (e.g. `wallaby/resources)
    # @return [Array]
    def _prefixes
      @_prefixes ||= PrefixesBuilder.new(
        super, controller_path, current_resources_name, params
      ).build
    end

    # A wrapped lookup content
    # Its aim is to render string partial when given partial is not found
    # @return [LookupContextWrapper]
    def lookup_context
      @_lookup_context ||= LookupContextWrapper.new super # rubocop:disable Naming/MemoizedInstanceVariableName
    end
  end
end

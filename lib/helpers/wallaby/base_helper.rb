module Wallaby
  # NOTE: Global helper methods should go in here
  module BaseHelper
    include StylingHelper
    include LinksHelper

    # @see ModelUtils.to_model_label
    # @return [String] label for given model class
    def to_model_label(model_class)
      ModelUtils.to_model_label model_class
    end

    # @see Map.resources_name_map
    # @return [String] resources name for given model class
    def to_resources_name(model_class)
      Map.resources_name_map model_class
    end

    # Generate body class from the following sources:
    # - `:action` parameter
    # - converted current resources name (e.g. `order__item` from `Order::Item`)
    # - `:custom_body_class` content
    # @return [String] css classes for body tag
    def body_class
      [
        params[:action],
        controller_path.gsub(SLASH, '__'),
        current_resources_name.try(:gsub, COLONS, '__'),
        content_for(:custom_body_class)
      ].compact.join SPACE
    end

    # Turn a list of classes into tree structure by inheritance.
    # @param classes [Array<Class>]
    #   a list of all the classes that wallaby supports
    # @return [Array<Wallaby::Node>] a tree structure of given classes
    def model_classes(classes = Map.model_classes)
      nested_hash = classes.each_with_object({}) do |klass, hash|
        hash[klass] = Node.new(klass)
      end
      nested_hash.each do |klass, node|
        node.parent = parent = nested_hash[klass.superclass]
        parent.children << node if parent
      end
      nested_hash.values.select { |v| v.parent.nil? }
    end

    # Turn the tree of classes into a nested `ul` list.
    # @param array [Array<Wallaby::Node>] root classes
    # @return [String] HTML for the whole tree
    def model_tree(array, base_class = nil)
      return EMPTY_STRING.html_safe if array.blank?
      options = { html_options: { class: 'dropdown-item' } }
      content_tag :ul, class: 'dropdown-menu', 'aria-labelledby': base_class do
        array.sort_by(&:name).each do |node|
          content = index_link(node.klass, options).try :<<, model_tree(node.children)
          concat content_tag(:li, content)
        end
      end
    end
  end
end

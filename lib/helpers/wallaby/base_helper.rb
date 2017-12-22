module Wallaby
  # NOTE: Global helper methods should go in here
  module BaseHelper
    include StylingHelper
    include LinksHelper

    # @see Utils.to_model_label
    def to_model_label(model_class)
      Utils.to_model_label model_class
    end

    # @see Map.resources_name_map
    def to_resources_name(model_class)
      Map.resources_name_map model_class
    end

    # @return [String] css classes for body tag
    def body_class
      [
        params[:action],
        current_resources_name.try(:gsub, COLONS, '__'),
        content_for(:custom_body_class)
      ].compact.join SPACE
    end

    # Turn a list of classes into tree structure
    # @param classes [Array] a list of all the classes that wallaby supports
    # @return [Array] a tree structure of given classes
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

    # @param array [Array] root classes
    # @return [String] HTML for the whole tree
    def model_tree(array)
      return EMPTY_STRING.html_safe if array.blank?
      content_tag :ul, class: 'dropdown-menu' do
        array.sort_by(&:name).each do |node|
          content = index_link(node.klass).try :<<, model_tree(node.children)
          concat content_tag(:li, content)
        end
      end
    end
  end
end

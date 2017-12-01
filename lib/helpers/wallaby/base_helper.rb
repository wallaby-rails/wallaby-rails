module Wallaby
  # NOTE: Global helper methods should go in here
  module BaseHelper
    include StylingHelper
    include LinksHelper

    def to_model_label(model_class)
      Utils.to_model_label model_class
    end

    def to_resources_name(model_class)
      Map.resources_name_map model_class
    end

    def body_class
      [
        params[:action],
        current_resources_name.try(:gsub, COLONS, '__'),
        content_for(:custom_body_class)
      ].compact.join SPACE
    end

    def ct(key, options = {})
      warn '[DEPRECATION] `ct` will be removed in version 5.2.0.'
      t key, { raise: true }.merge(options)
    rescue ::I18n::MissingTranslationData => e
      keys = ::I18n.normalize_keys(e.locale, e.key, e.options[:scope])
      keys.last.to_s.titleize
    end

    def random_uuid
      SecureRandom.uuid
    end

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

    def model_tree(arr)
      return EMPTY_STRING.html_safe if arr.blank?
      content_tag :ul, class: 'dropdown-menu' do
        arr.sort_by(&:name).each do |node|
          content = index_link(node.klass).try :<<, model_tree(node.children)
          concat content_tag(:li, content)
        end
      end
    end
  end
end

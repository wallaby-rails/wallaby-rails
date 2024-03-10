# frozen_string_literal: true

module Wallaby
  # Convert strings
  module Inflector
    extend self

    # @param name [String]
    # @return [String] class name
    # @return [nil] if name is blank
    def to_class_name(name)
      return EMPTY_STRING if name.blank?

      name = name.to_s unless name.is_a?(String)
      name.gsub(COLONS, SLASH).classify
    end

    # @param script_name [String]
    # @param resources_name [Class,String]
    # @param suffix [String,nil]
    # @return [String] generate the prefix for all classes
    def to_script(script_name, resources_name, suffix = nil)
      normalized_suffix = suffix.try(:underscore).try(:gsub, /\A_?/, UNDERSCORE)
      "#{script_name}/#{resources_name}#{normalized_suffix}".gsub(%r{\A/+}, EMPTY_STRING)
    end

    # @param script_name [String]
    # @param resources_name [Class,String]
    # @return [String] controller name
    def to_controller_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resources_name(resources_name), CONTROLLER))
    end

    # @param script_name [String]
    # @param resources_name [Class,String]
    # @return [String] decorator name
    def to_decorator_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), DECORATOR))
    end

    # @param script_name [String]
    # @param resources_name [Class,String]
    # @return [String] authorizer name
    def to_authorizer_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), AUTHORIZER))
    end

    # @param script_name [String]
    # @param resources_name [Class,String]
    # @return [String] servicer name
    def to_servicer_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), SERVICER))
    end

    # @param script_name [String]
    # @param resources_name [Class,String]
    # @return [String] paginator name
    def to_paginator_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), PAGINATOR))
    end

    # @param name [Class, String]
    # @return [String] resources name
    def to_resources_name(name)
      return EMPTY_STRING if name.blank?

      name = name.to_s unless name.is_a?(String)
      name.tableize.gsub(SLASH, COLONS)
    end

    # @param name [Class, String]
    # @return [String] resource name
    def to_resource_name(name)
      to_resources_name(name).singularize
    end

    # @param name [Class, String]
    # @return [String] resource name
    def to_model_name(name)
      to_class_name(to_resource_name(name))
    end

    # Produce model label (e.g. `Namespace / Product`) for model class (e.g. `Namespace::Product`)
    # @param model_class [Class, String] model class
    # @return [String] model label
    def to_model_label(model_class)
      # TODO: change to use i18n translation
      return EMPTY_STRING if model_class.blank?

      model_class_name = to_model_name model_class
      model_class_name.titleize.gsub(SLASH, SPACE + SLASH + SPACE)
    end
  end
end

module Wallaby
  # Utils
  module Utils
    def self.to_resources_name(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class.to_s.underscore.gsub(SLASH, COLONS).pluralize
    end

    def self.to_model_label(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class_name = to_model_name model_class
      model_class_name.titleize.gsub(SLASH, SPACE + SLASH + SPACE)
    end

    def self.to_model_name(resources_name)
      return EMPTY_STRING if resources_name.blank?
      resources_name.to_s.singularize.gsub(COLONS, SLASH).camelize
    end

    def self.to_model_class(resources_name, source = nil)
      return if resources_name.blank?
      class_name = to_model_name resources_name
      return class_name.constantize if Object.const_defined? class_name
      message = [class_name, source].compact.join(' from ')
      raise Wallaby::ModelNotFound, message
    end

    def self.to_hash(array)
      Hash[*array.flatten(1)]
    end
  end
end

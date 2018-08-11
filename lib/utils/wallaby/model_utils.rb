module Wallaby
  # Utils
  module ModelUtils
    # Convert model class (e.g. `Namespace::Product`) into resources name (e.g. `namespace::products`)
    # @param model_class [Class, String] model class
    # @return [String] resources name
    def self.to_resources_name(model_class)
      return EMPTY_STRING if model_class.blank?
      model_class.to_s.underscore.gsub(SLASH, COLONS).pluralize
    end

    # Convert model class (e.g. `Namespace::Product`) into model label (e.g. `Namespace / Product`)
    # @param model_class [Class, String] model class
    # @return [String] model label
    def self.to_model_label(model_class)
      # TODO: change to use i18n translation
      return EMPTY_STRING if model_class.blank?
      model_class_name = to_model_name model_class
      model_class_name.titleize.gsub(SLASH, SPACE + SLASH + SPACE)
    end

    # Convert resources name (e.g. `namespace::products`) into model class
    # (e.g. `Namespace::Product`)
    # @param resources_name [String] resources name
    # @return [Class, nil] model class
    def self.to_model_class(resources_name)
      return if resources_name.blank?
      class_name = to_model_name resources_name
      class_name.constantize
    rescue
      Rails.logger.warn I18n.t('errors.not_found.model', model: class_name)
      nil
    end

    # Convert resources name (e.g. `namespace::products`) into model name
    # (e.g. `Namespace::Product`)
    # @param resources_name [String] resources name
    # @return [String] model name
    def self.to_model_name(resources_name)
      return EMPTY_STRING if resources_name.blank?
      resources_name.to_s.singularize.gsub(COLONS, SLASH).camelize
    end
  end
end

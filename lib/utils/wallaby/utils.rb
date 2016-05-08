module Wallaby::Utils
  def self.to_resources_name(model_class)
    return '' if model_class.blank?
    model_class.to_s.underscore.gsub('/', '::').pluralize
  end

  def self.to_model_label(model_class)
    model_class_name = to_model_name model_class
    model_class_name.titleize.gsub '/', ' / '
  end

  def self.to_model_name(resources_name)
    return '' if resources_name.blank?
    resources_name.to_s.singularize.gsub('::', '/').camelize
  end

  def self.to_model_class(resources_name)
    return if resources_name.blank?
    class_name = to_model_name resources_name
    class_name.constantize rescue
      fail Wallaby::ModelNotFound.new class_name
  end

  def self.to_hash(array)
    Hash[ *array.flatten(1) ]
  end
end

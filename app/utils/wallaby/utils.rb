module Wallaby::Utils
  def self.to_resources_name model_class
    model_class.to_s.underscore.gsub('/', '::').pluralize
  end

  def self.to_model_name resources_name
    resources_name.to_s.singularize.gsub('::', '/').camelize
  end

  def self.to_model_label model_class
    model_class.to_s.titleize.gsub '/', ' / '
  end
end
module Wallaby::Utils
  def self.to_resources_name class_name
    class_name.underscore.gsub('/', '::').pluralize
  end

  def self.to_model_name resources_name
    resources_name.singularize.gsub('::', '/').camelize
  end
end
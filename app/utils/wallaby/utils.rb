module Wallaby::Utils
  def self.to_resources_name class_name
    class_name.underscore.gsub('/', '::').pluralize
  end
end
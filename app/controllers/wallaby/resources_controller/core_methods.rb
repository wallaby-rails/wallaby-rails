module Wallaby::ResourcesController::CoreMethods
  extend ActiveSupport::Concern

  class_methods do
    def resources_name
      unless self == Wallaby::ResourcesController
        Wallaby::Utils.to_resources_name name.gsub('Controller', '')
      end
    end

    def model_class
      unless self == Wallaby::ResourcesController
        Wallaby::Utils.to_model_name(resources_name).constantize
      end
    end
  end

  def resources_name
    self.class.resources_name || params[:resources]
  end

  def resource_name
    resources_name.singularize
  end

  def model_class
    self.class.model_class || Wallaby::Utils.to_model_name(resource_name).constantize
  end
end
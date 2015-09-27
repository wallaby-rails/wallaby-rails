module Wallaby::ResourcesController::CoreMethods
  extend ActiveSupport::Concern

  class_methods do
    def resources_name condition = self < Wallaby::ResourcesController
      if condition
        Wallaby::Utils.to_resources_name name.gsub('Controller', '')
      end
    end

    def model_class target_resources_name = resources_name, condition = self < Wallaby::ResourcesController
      if condition
        Wallaby::Utils.to_model_name(target_resources_name).constantize
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
    self.class.model_class || self.class.model_class(resource_name, true)
  end

  def model_decorator
    @model_decorator ||= Wallaby::ModelDecoratorFinder.find model_class
  end

  def decorator
    @decorator ||= Wallaby::ResourceDecoratorFinder.find model_class
  end

  def id
    params[:id]
  end
end
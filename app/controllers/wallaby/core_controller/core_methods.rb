module Wallaby::CoreController::CoreMethods
  extend ActiveSupport::Concern

  included do
    helper_method \
      :model_class,
      :resources_name,
      :model_decorator, :resource_decorator, :decorate,
      :collection, :resource,
      :resource_id, :resource_params
  end

  class_methods do
    def resources_name(condition = self < Wallaby::ResourcesController)
      if condition
        Wallaby::Utils.to_resources_name name.gsub('Controller', '')
      end
    end

    def model_class(target_resources_name = resources_name, condition = self < Wallaby::ResourcesController)
      if condition
        class_name = Wallaby::Utils.to_model_name target_resources_name
        class_name.constantize rescue
          fail Wallaby::ModelNotFound.new class_name
      end
    end
  end

  def resources_name(resource = nil)
    if resource
      Wallaby::Utils.to_resources_name resource.class
    else
      self.class.resources_name || params[:resources]
    end
  end

  def model_class
    self.class.model_class ||
    self.class.model_class(resources_name.singularize, true)
  end

  def model_decorator(model_class = nil)
    if model_class
      Wallaby::DecoratorFinder.find_model model_class
    else
      @model_decorator ||= Wallaby::DecoratorFinder.find_model self.model_class
    end
  end

  def resource_decorator(resource = nil)
    if resource
      Wallaby::DecoratorFinder.find_resource resource.class
    else
      @resource_decorator ||= Wallaby::DecoratorFinder.find_resource model_class
    end
  end

  def decorate(resource)
    if resource.respond_to? :map # collection
      resource.map do |item|
        decorate item
      end
    else
      resource_decorator(resource).decorate resource
    end
  end

  def collection
    @collection ||= model_decorator.collection params
  end

  def resource
    @resource ||= model_decorator.find_or_initialize resource_id
  end

  def resource_id
    params[:id]
  end

  def resource_params
    params.require(model_decorator.form_require_name)
      .permit *model_decorator.form_strong_param_names
  end
end

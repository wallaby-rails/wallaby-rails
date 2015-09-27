module Wallaby::ResourcesController::HelperMethods
  extend ActiveSupport::Concern
  included do
    helper_method  :collection, :resource, :model_class, :resources_name, :resource_name, :resource_params, :id, :model_decorator, :decorator
  end

  protected
  def collection
    @collection ||= model_decorator.collection
  end

  def resource
    @resource ||= model_decorator.find_or_initialize id
  end

  def resource_params
    # can be overridden
    white_list_fields = model_class.column_names.reject{ |v| v == 'id' }
    params.require(resource_name).permit *white_list_fields
  end
end
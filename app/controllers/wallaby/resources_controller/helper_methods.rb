module Wallaby::ResourcesController::HelperMethods
  extend ActiveSupport::Concern
  included do
    helper_method  :records, :record, :new_record, :model_class, :resources_name, :resource_name, :resource_params, :decorator, :id
  end

  protected
  def records
    @records ||= resources_set model_class.where(nil)
  end

  def record
    @record ||= resource_set model_class.find(id) if id.present?
  end

  def new_record
    @new_record ||= resource_set model_class.new
  end

  def resource_params
    # can be overridden
    white_list_fields = model_class.column_names.reject{ |v| v == 'id' }
    params.require(resource_name).permit *white_list_fields
  end

  def decorator target_model_class = model_class, target_record = record
    Wallaby::Decorator.build target_model_class, target_record
  end

  def id
    params[:id]
  end

  def resources_set value
    instance_variable_set "@#{ resources_name }", value
  end

  def resource_set value
    instance_variable_set "@#{ resource_name }", value
  end
end
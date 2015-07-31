module Wallaby::ResourcesController::CreateAction
  def created?
    new_record.assign_attributes resource_params
    new_record.save
  rescue ActionController::ParameterMissing
    false
  end

  def create_success
    redirect_to wallaby_engine.resource_path(resources_name, new_record.id), notice: 'successfully created'
  end

  def create_error
    flash[:error] = 'failed to create'
    render :new
  end
end
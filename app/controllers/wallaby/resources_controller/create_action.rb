module Wallaby::ResourcesController::CreateAction
  def created?
    resource.assign_attributes resource_params
    resource.save
  rescue ActionController::ParameterMissing
    false
  end

  def create_success
    redirect_to wallaby_engine.resource_path(resources_name, resource.id), notice: 'successfully created'
  end

  def create_error
    flash.now[:error] = 'failed to create'
    render :new
  end
end

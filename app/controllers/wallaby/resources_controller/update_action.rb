module Wallaby::ResourcesController::UpdateAction
  def updated?
    resource.update resource_params
  rescue ActionController::ParameterMissing
    false
  end

  def update_success
    redirect_to wallaby_engine.resource_path(resources_name, resource.id), notice: 'successfully updated'
  end

  def update_error
    flash.now[:error] = 'failed to update'
    render :edit
  end
end

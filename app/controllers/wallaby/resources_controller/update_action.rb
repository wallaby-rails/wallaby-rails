module Wallaby::ResourcesController::UpdateAction
  def updated?
    record.update resource_params
  rescue ActionController::ParameterMissing
    false
  end

  def update_success
    redirect_to wallaby_engine.resource_path(resources_name, record.id), notice: 'successfully updated'
  end

  def update_error
    flash[:error] = 'failed to update'
    render :edit
  end
end
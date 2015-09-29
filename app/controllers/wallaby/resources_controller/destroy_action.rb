module Wallaby::ResourcesController::DestroyAction
  def destroyed?
    resource.destroy
  end

  def destroy_success
    redirect_to wallaby_engine.resource_path(resources_name, resource.id), notice: 'successfully destroyed'
  end

  def destroy_error
    redirect_to wallaby_engine.resource_path(resources_name, resource.id), error: 'failed to destroy'
  end
end
module Wallaby::ResourcesController::DestroyAction
  def destroyed? record
    record.destroy
  end

  def destroy_success
    redirect_to wallaby_engine.resource_path(resources_name, record.id), notice: 'successfully destroyed'
  end

  def destroy_error
    redirect_to wallaby_engine.resource_path(resources_name, record.id), error: 'failed to destroy'
  end
end
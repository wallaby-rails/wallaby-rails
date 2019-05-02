class ProfileServicer < Wallaby::ModelServicer
  def permit(params, action)
    params.fetch(:profile, params).permit(model_decorator.form_field_names)
  end

  def new(params)
    Profile.new
  end

  def find(id, params)
    Profile.find
  end

  def create(resource, params)
    resource.assign params
    resource.id = Random.rand(1000)
    Profile.save resource
  end

  def update(resource, params)
    resource.assign params
    Profile.save resource
  end

  def destroy(resource, params)
    Profile.destroy resource
  end
end

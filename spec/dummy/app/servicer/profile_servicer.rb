# frozen_string_literal: true

class ProfileServicer < Wallaby::ModelServicer
  def permit(params, action)
    params.fetch(model_class.to_s.underscore, params).permit(model_decorator.form_field_names)
  end

  def new(params)
    model_class.new
  end

  def find(id, params)
    model_class.find
  end

  def create(resource, params)
    resource.assign params
    resource.id = Random.rand(1000)
    model_class.save resource
  end

  def update(resource, params)
    resource.assign params
    model_class.save resource
  end

  def destroy(resource, params)
    model_class.destroy resource
  end
end

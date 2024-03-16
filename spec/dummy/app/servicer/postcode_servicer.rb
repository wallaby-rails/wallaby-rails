# frozen_string_literal: true

class PostcodeServicer < Wallaby::ModelServicer
  def permit(params, _action)
    params.fetch(:postcode, params).permit(model_decorator.form_field_names)
  end

  def collection(_params)
    Postcode.all
  end

  def paginate(query, _params)
    query
  end

  def new(_params)
    Postcode.new
  end

  def find(id, _params)
    Postcode.find id
  end

  def create(resource, params)
    resource.assign params
    Postcode.create resource
  end

  def update(resource, params)
    resource.assign params
    Postcode.update resource
  end

  def destroy(resource, _params)
    Postcode.destroy resource
  end
end

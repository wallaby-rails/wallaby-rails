class Wallaby::ActiveRecord::ModelServicer
  def initialize(model_class)
    @model_class = model_class
  end

  def create(params)
    resource = @model_class.new
    resource.assign_attributes params
    resource.save
    [ resource, resource.errors.blank? ]
  end

  def update(id, params)
    resource = @model_class.find id
    resource.assign_attributes params
    resource.save
    [ resource, resource.errors.blank? ]
  rescue
    [ nil, false ]
  end

  def destroy(id)
    @model_class.delete id
  end
end

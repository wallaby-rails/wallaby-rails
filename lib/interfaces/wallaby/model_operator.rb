class Wallaby::ModelOperator
  def initialize(model_class, model_decorator = nil)
    fail ArgumentError, 'model class required' unless model_class
    @model_class      = model_class
    @model_decorator  = model_decorator || Wallaby::DecoratorFinder.find_model(@model_class)
  end

  def collection(params, ability)
    fail Wallaby::NotImplemented
  end

  def new(params)
    fail Wallaby::NotImplemented
  end

  def find(id, params)
    fail Wallaby::NotImplemented
  end

  def create(params, ability)
    fail Wallaby::NotImplemented
  end

  def update(resource, params, ability)
    fail Wallaby::NotImplemented
  end

  def destroy(resource, params)
    fail Wallaby::NotImplemented
  end
end

class Wallaby::ModelServicer
  def self.model_class
    if self < Wallaby::ModelServicer
      Wallaby::Utils.to_model_class name.gsub('Servicer', ''), name
    end
  end

  def initialize(model_class = nil, model_decorator = nil)
    @model_class      = model_class || self.class.model_class
    fail ArgumentError, 'model class required' unless @model_class
    @model_decorator  = model_decorator || Wallaby::DecoratorFinder.find_model(@model_class)
    @delegator        = Wallaby.adaptor.model_operator.new @model_class, @model_decorator
  end

  def collection(params, ability)
    @delegator.collection params, ability
  end

  def new(params)
    @delegator.new params
  end

  def find(id, params)
    @delegator.find id, params
  end

  def create(params, ability)
    @delegator.create params, ability
  end

  def update(resource, params, ability)
    @delegator.update resource, params, ability
  end

  def destroy(resource, params)
    @delegator.destroy resource, params
  end
end

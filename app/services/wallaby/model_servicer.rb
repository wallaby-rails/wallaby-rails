class Wallaby::ModelServicer
  def self.model_class
    if self < Wallaby::ModelServicer
      class_name = name.gsub('Servicer', '')
      class_name.constantize rescue fail Wallaby::ModelNotFound, class_name
    end
  end

  def initialize(model_class = nil, model_decorator = nil)
    @model_class      = model_class || self.class.model_class
    fail ArgumentError, 'model class required' unless @model_class
    @model_decorator  = model_decorator || Wallaby::DecoratorFinder.find_model(@model_class)
    @servicer         = Wallaby.adaptor.model_servicer.new @model_class, @model_decorator
  end

  def collection(params, ability)
    @servicer.collection params, ability
  end

  def new(params)
    @servicer.new params
  end

  def find(id, params)
    @servicer.find id, params
  end

  def create(params, ability)
    @servicer.create params, ability
  end

  def update(resource, params, ability)
    @servicer.update resource, params, ability
  end

  def destroy(resource, params)
    @servicer.destroy resource, params
  end
end

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
    @model_decorator  = model_decorator
    @servicer         = Wallaby.adaptor.model_servicer.new @model_class, @model_decorator
  end

  delegate *%i( collection new find create update destroy ), to: :@servicer
end

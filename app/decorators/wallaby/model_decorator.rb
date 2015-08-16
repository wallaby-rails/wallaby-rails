class Wallaby::ModelDecorator
  attr_reader :model_class
  def initialize model_class
    @model_class = model_class
  end
end
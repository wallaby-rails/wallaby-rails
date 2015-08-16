class Wallaby::Services::ModelDecoratorFinder
  def self.find model_class
    target_decorator_class = Wallaby::RecordDecorator.subclasses.find do |klass|
      klass.model_class == model_class
    end
    target_decorator_class || Wallaby::ModelDecorator.new(model_class)
  end
end
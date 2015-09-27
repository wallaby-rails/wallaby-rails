class Wallaby::ModelDecoratorFinder
  def self.find model_class
    Wallaby::ResourceDecorator.try do |base|
      base.subclasses.find do |klass|
        klass.model_class == model_class
      end || base.model_decorator(model_class)
    end
  end
end
class Wallaby::DecoratorFinder
  def self.find_model model_class
    Wallaby::ResourceDecorator.try do |base|
      base.subclasses.find do |klass|
        klass.model_class == model_class
      end || base.model_decorator(model_class)
    end
  end

  def self.find_resource model_class
    Wallaby::ResourceDecorator.try do |base|
      base.subclasses.find do |klass|
        klass.model_class == model_class
      end || base
    end
  end
end
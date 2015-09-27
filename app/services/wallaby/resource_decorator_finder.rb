class Wallaby::ResourceDecoratorFinder
  def self.find model_class
    Wallaby::ResourceDecorator.try do |base|
      base.subclasses.find do |klass|
        klass.model_class == model_class
      end || base
    end
  end
end
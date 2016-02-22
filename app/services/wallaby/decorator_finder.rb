class Wallaby::DecoratorFinder
  DEFAULT_DECORATOR = Wallaby::ResourceDecorator

  def self.find_model(model_class)
    find_class(model_class) ||
    DEFAULT_DECORATOR.model_decorator(model_class)
  end

  def self.find_resource(model_class)
    find_class(model_class) || DEFAULT_DECORATOR
  end

  protected
  def self.cached_subclasses
    Rails.cache.fetch 'wallaby/decorator_finder' do
      DEFAULT_DECORATOR.subclasses.reject do |klass|
        klass.name.blank?
      end
    end
  end

  def self.find_class(model_class)
    cached_subclasses.find do |klass|
      klass.model_class == model_class
    end
  end
end

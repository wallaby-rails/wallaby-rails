module Wallaby
  # Decorator finder
  class DecoratorFinder
    DEFAULT_DECORATOR = Wallaby::ResourceDecorator

    def self.find_model(model_class)
      Wallaby::Map.decorator_map[model_class] || new_model(model_class)
    end

    def self.find_resource(model_class)
      Wallaby::Map.decorator_map[model_class] || DEFAULT_DECORATOR
    end

    def self.new_model(model_class)
      mode = Wallaby::ActiveRecord
      mode.model_decorator.new model_class
    end
  end
end

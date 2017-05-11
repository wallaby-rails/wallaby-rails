module Wallaby
  # Global storage of all the maps for model classes
  class Map
    # { model => mode }
    def self.mode_map
      @mode_map ||= ModeMapper.new(Mode.subclasses).map.freeze
    end

    # [ model classes ]
    def self.model_classes
      @model_classes ||=
        ModelClassCollector.new(::Wallaby.configuration).collect.freeze
    end

    # { model => controller }
    def self.controller_map(model_class)
      @controller_map ||= ModelClassMapper.new(ResourcesController).map
      @controller_map[model_class] ||= ResourcesController
    end

    # { model => model decorator }
    def self.model_decorator_map(model_class)
      @model_decorator_map ||= {}
      @model_decorator_map[model_class] ||= begin
        mode = mode_map[model_class]
        mode.model_decorator.new model_class if mode
      end
    end

    # { model => resource decorator }
    def self.resource_decorator_map(model_class)
      @resource_decorator_map ||= ModelClassMapper.new(ResourceDecorator).map
      @resource_decorator_map[model_class] ||= ResourceDecorator
    end

    # { model => servicer }
    def self.servicer_map(model_class)
      @servicer_map ||=
        ModelClassMapper.new(ModelServicer).map do |klass|
          klass.new(klass.model_class)
        end
      @servicer_map[model_class] ||= ModelServicer.new(model_class)
    end

    # { model => handler }
    def self.handler_map(model_class)
      @handler_map ||= {}
      @handler_map[model_class] ||= begin
        mode = mode_map[model_class]
        mode.model_handler.new model_class if mode
      end
    end

    # { model => resources name }
    def self.resources_name_map(model_class)
      @resources_name_map ||= {}
      @resources_name_map[model_class] ||= Utils.to_resources_name model_class
    end

    # { resources name => model }
    def self.model_class_map(resources_name)
      @model_class_map ||= {}
      @model_class_map[resources_name] ||= Utils.to_model_class resources_name
    end

    # Clear all the class variables to nil
    def self.clear
      @mode_map = nil
      @model_classes = nil
      @controller_map = nil
      @model_decorator_map = nil
      @resource_decorator_map = nil
      @servicer_map = nil
      @handler_map = nil
      @model_class_map = nil
      @resources_name_map = nil
    end
  end
end

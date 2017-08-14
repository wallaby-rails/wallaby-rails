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
      @servicer_map ||= ModelClassMapper.new(ModelServicer).map
      @servicer_map[model_class] ||= ModelServicer
    end

    # { model => service_provider }
    def self.service_provider_map(model_class)
      @service_provider_map ||= {}
      @service_provider_map[model_class] ||= begin
        mode = mode_map[model_class]
        mode.model_service_provider.new model_class if mode
      end
    end

    # { model => paginator }
    def self.paginator_map(model_class)
      @paginator_map ||= ModelClassMapper.new(ResourcePaginator).map
      @paginator_map[model_class] ||= ResourcePaginator
    end

    # { model => pagination_provider }
    def self.pagination_provider_map(model_class)
      @pagination_provider_map ||= {}
      @pagination_provider_map[model_class] ||=
        mode_map[model_class].try(:model_pagination_provider)
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
      @mode_map, @model_classes, @controller_map, @model_decorator_map,
      @resource_decorator_map, @servicer_map, @service_provider_map,
      @paginator_map, @pagination_provider_map, @model_class_map,
      @resources_name_map = []
    end
  end
end

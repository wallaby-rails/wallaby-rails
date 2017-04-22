module Wallaby
  # Global storage of all the maps for model classes
  class Map
    def self.mode_map
      @mode_map ||= ModeMapper.new(Wallaby::Mode.subclasses).map
    end

    def self.model_classes
      @model_classes ||=
        ModelClassCollector.new(Wallaby.configuration).collect
    end

    def self.controller_map
      @controller_map ||=
        ModelClassMapper.new(Wallaby::ResourcesController).map
    end

    def self.decorator_map
      @decorator_map ||=
        ModelClassMapper.new(Wallaby::ResourceDecorator).map
    end

    def self.servicer_map
      @servicer_map ||=
        ModelClassMapper.new(Wallaby::ModelServicer).map
    end

    # Clear all the class variables to nil
    def self.clear
      @mode_map = nil
      @model_classes = nil
      @controller_map = nil
      @decorator_map = nil
      @servicer_map = nil
    end
  end
end

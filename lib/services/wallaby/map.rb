module Wallaby
  # @private
  # Global mappings
  class Map
    class << self
      # { model => mode }
      # @return [Hash] { model => mode }
      def mode_map
        @mode_map ||= ModeMapper.new(Mode.descendants).map.freeze
      end

      # @return [Array] [ model classes ]
      def model_classes
        @model_classes ||= ModelClassCollector.new(configuration).collect.freeze
      end

      # { model => controller }
      # @param model_class [Class]
      # @return [Class] controller class
      #   default to `mapping.resources_controller`
      def controller_map(model_class)
        @controller_map ||=
          ModelClassMapper.new(mapping.resources_controller).map
        @controller_map[model_class] ||= mapping.resources_controller
      end

      # { model => model decorator }
      # @param model_class [Class]
      # @return [Wallaby::ModelDecorator] model decorator instance
      def model_decorator_map(model_class)
        @model_decorator_map ||= {}
        @model_decorator_map[model_class] ||= begin
          mode = mode_map[model_class]
          mode.model_decorator.new model_class if mode # rubocop:disable Style/SafeNavigation, Metrics/LineLength
        end
      end

      # { model => resource decorator }
      # @param model_class [Class]
      # @return [Class] resource decorator class
      #   default to `mapping.resource_decorator`
      def resource_decorator_map(model_class)
        @resource_decorator_map ||=
          ModelClassMapper.new(mapping.resource_decorator).map
        @resource_decorator_map[model_class] ||= begin
          mapping.resource_decorator if mode_map[model_class]
        end
      end

      # { model => servicer }
      # @param model_class [Class]
      # @return [Class] resource servicer class
      #   default to `mapping.resource_servicer`
      def servicer_map(model_class)
        @servicer_map ||= ModelClassMapper.new(mapping.model_servicer).map
        @servicer_map[model_class] ||= begin
          mapping.model_servicer if mode_map[model_class]
        end
      end

      # { model => service_provider }
      # @param model_class [Class]
      # @return [Wallaby::ModelServiceProvider] model service provider instance
      def service_provider_map(model_class)
        @service_provider_map ||= {}
        @service_provider_map[model_class] ||= begin
          mode = mode_map[model_class]
          mode.model_service_provider.new model_class if mode # rubocop:disable Style/SafeNavigation, Metrics/LineLength
        end
      end

      # { model => paginator }
      # @param model_class [Class]
      # @return [Hash] { model => paginator }
      def paginator_map(model_class)
        @paginator_map ||= ModelClassMapper.new(mapping.resource_paginator).map
        @paginator_map[model_class] ||= begin
          mapping.resource_paginator if mode_map[model_class]
        end
      end

      # { model => pagination_provider }
      # @param model_class [Class]
      # @return [Class] model pagination provider class
      def pagination_provider_map(model_class)
        @pagination_provider_map ||= {}
        @pagination_provider_map[model_class] ||=
          mode_map[model_class].try(:model_pagination_provider)
      end

      # { model => authorizer }
      # @param model_class [Class]
      # @return [Hash] { model => authorizer }
      def authorizer_map(model_class)
        @authorizer_map ||= ModelClassMapper.new(mapping.model_authorizer).map
        @authorizer_map[model_class] ||= begin
          mapping.model_authorizer if mode_map[model_class]
        end
      end

      # { model => resources name }
      # @param model_class [Class]
      # @return [String] resources name
      def resources_name_map(model_class)
        @resources_name_map ||= {}
        @resources_name_map[model_class] ||= Utils.to_resources_name model_class
      end

      # { resources name => model }
      # @param resources_name [String]
      # @return [Class] model class
      def model_class_map(resources_name)
        @model_class_map ||= {}
        @model_class_map[resources_name] ||= Utils.to_model_class resources_name
      end

      # Clear all the class variables to nil
      def clear
        @mode_map, @model_classes, @controller_map, @model_decorator_map,
        @resource_decorator_map, @servicer_map, @service_provider_map,
        @paginator_map, @pagination_provider_map, @model_class_map,
        @resources_name_map = []
      end

      private

      # shorthand method
      def configuration
        ::Wallaby.configuration
      end

      # shorthand method
      def mapping
        configuration.mapping
      end
    end
  end
end

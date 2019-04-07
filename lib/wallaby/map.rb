module Wallaby
  # Global storage to hold all the information that Wallaby needs to look up.
  class Map
    class << self
      # To store modes
      attr_writer :modes

      # @return [Array<Class>] descendants of Mode
      def modes
        @modes ||= Mode.descendants
      end

      # @return [Hash] { model => mode }
      def mode_map
        @mode_map ||= ModeMapper.new(modes).map.freeze
      end

      # TODO: remove this method
      # @return [Array] [ model classes ]
      def model_classes
        @model_classes ||= ModelClassCollector.new(configuration, mode_map.keys).collect.freeze
      end

      # { model => resources name }
      # It's a setter when value is given.
      # Otherwise, a getter.
      # @param model_class [Class]
      # @param value [String, nil] resources name
      # @return [String] resources name
      def resources_name_map(model_class, value = nil)
        @resources_name_map ||= {}
        @resources_name_map[model_class] ||= value || ModelUtils.to_resources_name(model_class)
      end

      # { resources name => model }
      # It's a setter when value is given.
      # Otherwise, a getter.
      # @param resources_name [String]
      # @return [Class]
      def model_class_map(resources_name, value = nil)
        @model_class_map ||= {}
        @model_class_map[resources_name] ||= value || ModelUtils.to_model_class(resources_name)
      end
    end

    class << self
      # Look up which controller to use for a given model class
      # @param model_class [Class]
      # @param application_controller [Class, nil]
      # @return [Class] controller class, default to `mapping.resources_controller`
      def controller_map(model_class, application_controller = nil)
        application_controller ||= mapping.resources_controller
        map_of :@controller_map, model_class, application_controller
      end

      # Look up which resource decorator to use for a given model class
      # @param model_class [Class]
      # @param application_decorator [Class, nil]
      # @return [Class] resource decorator class, default to `mapping.resource_decorator`
      def resource_decorator_map(model_class, application_decorator = nil)
        application_decorator ||= mapping.resource_decorator
        map_of :@decorator_map, model_class, application_decorator
      end

      # { model => model decorator }
      # @param model_class [Class]
      # @param application_decorator [Class, nil]
      # @return [Wallaby::ModelDecorator] model decorator instance
      def model_decorator_map(model_class, application_decorator = nil)
        application_decorator ||= mapping.resource_decorator
        @model_decorator_map ||= {}
        @model_decorator_map[application_decorator] ||= {}
        @model_decorator_map[application_decorator][model_class] ||=
          mode_map[model_class].try(:model_decorator).try :new, model_class
      end

      # Look up which model servicer to use for a given model class
      # @param model_class [Class]
      # @param application_servicer [Class, nil]
      # @return [Class] model servicer class, default to `mapping.model_servicer`
      def servicer_map(model_class, application_servicer = nil)
        application_servicer ||= mapping.model_servicer
        map_of :@servicer_map, model_class, application_servicer
      end

      # Look up which paginator to use for a given model class
      # @param model_class [Class]
      # @param application_paginator [Class, nil]
      # @return [Class] resource paginator class, default to `mapping.model_paginator`
      def paginator_map(model_class, application_paginator = nil)
        application_paginator ||= mapping.model_paginator
        map_of :@paginator_map, model_class, application_paginator
      end

      # Look up which authorizer to use for a given model class
      # @param model_class [Class]
      # @param application_authorizer [Class, nil]
      # @return [Class] model authorizer class, default to `mapping.model_authorizer`
      def authorizer_map(model_class, application_authorizer = nil)
        application_authorizer ||= mapping.model_authorizer
        map_of :@authorizer_map, model_class, application_authorizer
      end
    end

    class << self
      # { model => service_provider }
      # @param model_class [Class]
      # @return [Class] model service provider instance
      def service_provider_map(model_class)
        @service_provider_map ||= {}
        @service_provider_map[model_class] ||= mode_map[model_class].try :model_service_provider
      end

      # { model => pagination_provider }
      # @param model_class [Class]
      # @return [Class] model pagination provider class
      def pagination_provider_map(model_class)
        @pagination_provider_map ||= {}
        @pagination_provider_map[model_class] ||= mode_map[model_class].try :model_pagination_provider
      end

      # { model => authorizer_provider }
      # @param model_class [Class]
      # @return [Class] model authorizer provider class
      def authorizer_provider_map(model_class)
        @authorizer_provider_map ||= {}
        @authorizer_provider_map[model_class] ||= mode_map[model_class].try :model_authorization_providers
      end
    end

    class << self
      # Reset all the instance variables to nil
      def clear
        instance_variables.each { |name| instance_variable_set name, nil }
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

      # Set up the hash map for given variable name
      # @param variable_name [Symbol] instance variable name e.g. :@decorator_map
      # @param model_class [Class]
      # @param application_class [Class]
      # @return [Class]
      def map_of(variable_name, model_class, application_class)
        return unless model_class
        unless mode_map[model_class]
          Rails.logger.warn I18n.t('wallaby.map.missing_mode_for_model_class', model: model_class.name)
          return
        end
        instance_variable_set(variable_name, instance_variable_get(variable_name) || {})
        map = instance_variable_get variable_name
        map[application_class] ||= ModelClassMapper.map application_class.descendants
        map[application_class][model_class] ||= application_class
      end
    end
  end
end

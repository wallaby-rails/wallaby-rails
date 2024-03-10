# frozen_string_literal: true

module Wallaby
  # All the lookups that Wallaby needs.
  class Map
    class << self
      include Classifier

      # @!attribute [w] modes
      attr_writer :modes

      # @!attribute [r] modes
      # @return [Array<String>] all {Mode}s
      def modes
        @modes ||= ClassArray.new Mode.descendants
      end

      # @return [ClassHash] { Model Class => {Mode} }
      def mode_map
        @mode_map ||= begin
          # NOTE: this is the point where all model files should be required
          Preloader.require_models
          ModeMapper.execute(modes).freeze
        end
      end

      # @deprecated
      def model_classes
        Deprecator.alert method(__callee__), from: '0.3.0'
      end

      # { model => resources name }
      # It's a setter when value is given.
      # Otherwise, a getter.
      # @param model_class [Class]
      # @param value [String, nil] resources name
      # @return [String] resources name
      def resources_name_map(model_class, value = nil)
        @resources_name_map ||= ClassHash.new
        @resources_name_map[model_class] ||= value || Inflector.to_resources_name(model_class)
      end

      # { resources name => model }
      # It's a setter when value is given.
      # Otherwise, a getter.
      # @param resources_name [String]
      # @return [Class]
      def model_class_map(resources_name, value = nil)
        @model_class_map ||= ClassHash.new
        @model_class_map[resources_name] ||= value || Classifier.to_class(Inflector.to_model_name(resources_name))
      end
    end

    class << self
      # { model => model decorator }
      # @param model_class [Class]
      # @param application_decorator [Class]
      # @return [ModelDecorator] model decorator instance
      def model_decorator_map(model_class, application_decorator)
        @model_decorator_map ||= ClassHash.new
        @model_decorator_map[application_decorator] ||= ClassHash.new
        @model_decorator_map[application_decorator][model_class] ||=
          mode_map[model_class].try(:model_decorator).try :new, model_class
      end
    end

    class << self
      # { model => service_provider }
      # @param model_class [Class]
      # @return [Class] model service provider instance
      def service_provider_map(model_class)
        @service_provider_map ||= ClassHash.new
        @service_provider_map[model_class] ||= mode_map[model_class].try :model_service_provider
      end

      # { model => pagination_provider }
      # @param model_class [Class]
      # @return [Class] model pagination provider class
      def pagination_provider_map(model_class)
        @pagination_provider_map ||= ClassHash.new
        @pagination_provider_map[model_class] ||= mode_map[model_class].try :model_pagination_provider
      end

      # { model => authorizer_provider }
      # @param model_class [Class]
      # @return [Class] model authorizer provider class
      def authorizer_provider_map(model_class)
        @authorizer_provider_map ||= ClassHash.new
        @authorizer_provider_map[model_class] ||= mode_map[model_class].try :model_authorization_providers
      end
    end

    class << self
      # Reset all the instance variables to nil
      def clear
        instance_variables.each { |name| instance_variable_set name, nil }
      end
    end
  end
end

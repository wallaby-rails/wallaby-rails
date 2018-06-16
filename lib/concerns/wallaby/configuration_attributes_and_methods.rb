module Wallaby
  # Class attributes and methods for controller
  module ConfigurationAttributesAndMethods
    extend ActiveSupport::Concern

    class_methods do
      # @see .resources_name
      attr_writer :resources_name
      # @see .model_class
      attr_writer :model_class
      # @!attribute model_decorator
      #   This attribute will be used for `current_model_decorator`
      attr_accessor :model_decorator
      # @!attribute model_servicer
      #   This attribute will be used for `current_model_servicer`
      attr_accessor :model_servicer
      # @!attribute model_paginator
      #   This attribute will be used for `current_model_paginator`
      attr_accessor :model_paginator
      # @!attribute model_authorizer
      #   This attribute will be used for `current_model_authorizer`
      attr_accessor :model_authorizer

      # @!attribute [w] engine_name
      # @see .engine_name
      attr_writer :engine_name
      # @!attribute [w] application_decorator
      # @see .application_decorator
      attr_writer :application_decorator
      # @!attribute [w] application_servicer
      # @see .application_servicer
      attr_writer :application_servicer
      # @!attribute [w] application_paginator
      # @see .application_paginator
      attr_writer :application_paginator
      # @!attribute [w] application_authorizer
      # @see .application_authorizer
      attr_writer :application_authorizer
    end

    class_methods do
      # @!attribute [r] resources_name
      #   This attribute will be used by the `self.model_class`.
      #   @return [String] store the resources name. must be in plural.
      def resources_name
        return unless self < ResourcesController
        @resources_name || Map.resources_name_map(name.gsub('Controller', EMPTY_STRING))
      end

      # @!attribute [r] model_class
      #   This attribute will be used by the dynamic router to find out which
      #   controller to dispatch to. For example:
      #
      #   `/admin/products` will be dispatched to the controller that has the
      #   model class `Product`.
      #   @return [Class] the model class for controller.
      #   @example It can be customized as below:
      #     ```
      #     self.model_class = Product
      #     ```
      #     Or
      #     ```
      #     def self.model_class; Product; end
      #     ```
      def model_class
        return unless self < ResourcesController
        @model_class || \
          unless abstract || self == Wallaby.configuration.mapping.resources_controller
            Map.model_class_map(resources_name)
          end
      end

      # @!attribute [r] engine_name
      #   @return [String, nil]
      def engine_name
        @engine_name ||= from_superclass __callee__
      end
    end

    class_methods do
      # @!attribute [r] application_decorator
      #   @return [Class, nil]
      def application_decorator
        @application_decorator ||= from_superclass __callee__
      end

      # @!attribute [r] application_servicer
      #   @return [Class, nil]
      def application_servicer
        @application_servicer ||= from_superclass __callee__
      end

      # @!attribute [r] application_paginator
      #   @return [Class, nil]
      def application_paginator
        @application_paginator ||= from_superclass __callee__
      end

      # @!attribute [r] application_authorizer
      #   @return [Class, nil]
      def application_authorizer
        @application_authorizer ||= from_superclass __callee__
      end

      private

      # @param method [Symbol, String]
      def from_superclass(method)
        superclass.respond_to?(method) && superclass.send(method) || nil
      end
    end
  end
end

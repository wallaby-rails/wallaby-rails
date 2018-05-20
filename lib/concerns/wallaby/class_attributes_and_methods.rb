module Wallaby
  # Class attributes and methods for controller
  module ClassAttributesAndMethods
    extend ActiveSupport::Concern

    class_methods do
      # @see .model_class
      attr_writer :model_class
      # @see .model_decorator
      attr_writer :model_decorator
      # @see .model_servicer
      attr_writer :model_servicer
      # @see .model_paginator
      attr_writer :model_paginator
      # @see .model_authorizer
      attr_writer :model_authorizer
    end

    class_methods do
      # @!attribute resources_name
      #   This attribute will be used by the `self.model_class`.
      #   @return [String] store the resources name. must be in plural.
      def resources_name
        return unless self < configuration.mapping.resources_controller
        @resources_name \
          || Map.resources_name_map(name.gsub('Controller', EMPTY_STRING))
      end

      # @!attribute model_class
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
        return unless self < configuration.mapping.resources_controller
        @model_class \
          || Map.model_class_map(resources_name)
      end

      # @!attribute model_decorator
      #   This attribute will be used mainly in the view to tell Wallaby how to
      #   render the page according to its metadata.
      #   @return [Class] the model decorator class.
      #   @example It can be customized as below:
      #     ```
      #     self.model_decorator = ProductDecorator
      #     ```
      #     Or
      #     ```
      #     def self.model_decorator; ProductDecorator; end
      #     ```
      def model_decorator
        @model_decorator || Map.model_decorator_map(model_class)
      end

      # @!attribute model_servicer
      #   This attribute will be used mainly in the controller for CRUD
      #   operations.
      #   @return [Class] the model servicer class for controller.
      #   @example It can be customized as below:
      #     ```
      #     self.model_servicer = ProductServicer
      #     ```
      #     Or
      #     ```
      #     def self.model_servicer; ProductServicer; end
      #     ```
      def model_servicer
        @model_servicer || Map.servicer_map(model_class)
      end

      # @!attribute model_paginator
      #   This attribute will be used mainly in the view for pagination.
      #   @return [Class] the model paginator class for controller.
      #   @example It can be customized as below:
      #     ```
      #     self.model_paginator = ProductPaginator
      #     ```
      #     Or
      #     ```
      #     def self.model_paginator; ProductPaginator; end
      #     ```
      def model_paginator
        @model_paginator || Map.paginator_map(model_class)
      end

      # @!attribute model_authorizer
      #   This attribute will be used in both controller and view for
      #   authroization.
      #   @return [Class] the model authorizer class for controller.
      #   @example It can be customized as below:
      #     ```
      #     self.model_authorizer = PunditAuthorizer
      #     ```
      #     Or
      #     ```
      #     def self.model_authorizer; PunditAuthorizer; end
      #     ```
      def model_authorizer
        @model_authorizer || Map.authorizer_map(model_class)
      end
    end
  end
end

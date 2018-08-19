module Wallaby
  # Resources related attributes
  module Resourcable
    # Configurable attribute
    module ClassMethods
      # @!attribute [w] resources_name
      attr_writer :resources_name

      # @!attribute [r] resources_name
      # If Wallaby doesn't get it right, please specify the **resources_name**.
      # @example To set model paginator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.resources_name = 'products'
      #   end
      # @return [String] resource names
      def resources_name
        return unless self < ResourcesController
        return if abstract || self == Wallaby.configuration.mapping.resources_controller
        @resources_name ||= Map.resources_name_map(controller_path)
      end

      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # This attribute will be used by the dynamic router to find out which
      # controller to dispatch to. For example:
      #
      # `/admin/products` will be dispatched to the controller that has the
      # model class `Product`.
      # @return [Class] the model class for controller.
      # @example It can be customized as below:
      #   ```
      #   self.model_class = Product
      #   ```
      #   Or
      #   ```
      #   def self.model_class; Product; end
      #   ```
      # @example To set model paginator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_class = ProductResources
      #   end
      # @raise [ArgumentError] when **model_class** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelResources
      # @return [Class] model paginator
      def model_class
        @model_class ||= Map.model_class_map(resources_name)
      end
    end

    def current_resources_name
      @current_resources_name ||= params[:resources] || controller_to_get(__callee__, :resources_name)
    end

    def current_model_class
      @current_model_class ||=
        controller_to_get(__callee__, :model_class) || Map.model_class_map(current_resources_name)
    end
  end
end

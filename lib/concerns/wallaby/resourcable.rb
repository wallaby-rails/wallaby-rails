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

    # Shorthand of params[:id]
    # @return [String, nil] ID param
    def resource_id
      params[:id]
    end

    # @return [#each] a collection of all the records
    def collection
      @collection ||= paginate current_servicer.collection params
    end

    # @return [Object] either persisted or unpersisted resource instance
    def resource
      @resource ||= begin
        # white-listed params
        whitelisted = action_name.in?(SAVE_ACTIONS) ? resource_params : {}
        if resource_id.present?
          current_servicer.find resource_id, whitelisted
        else
          current_servicer.new whitelisted
        end
      end
    end

    protected

    # To paginate the collection but only when either `page` or `per` param is given,
    # or HTML response is requested
    # @see Wallaby::ModelServicer#paginate
    # @param query [#each]
    # @return [#each]
    def paginate(query)
      paginatable = params[:page] || params[:per] || request.format.symbol == :html
      paginatable ? current_servicer.paginate(query, params) : query
    end
  end
end

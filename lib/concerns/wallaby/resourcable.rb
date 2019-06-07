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
        return if base_class? || self == Wallaby.configuration.mapping.resources_controller
        @resources_name ||=
          Map.resources_name_map controller_path.gsub(%r{^#{namespace.try(:underscore)}/}, EMPTY_STRING)
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
      # @return [Class] model paginator
      # @raise [ArgumentError] when **model_class** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelResources
      def model_class
        @model_class ||= Map.model_class_map(resources_name)
      end
    end

    # @return [String] resources name for current request
    def current_resources_name
      @current_resources_name ||= params[:resources] || controller_to_get(__callee__, :resources_name)
    end

    # @return [Class] model class for current request
    def current_model_class
      @current_model_class ||=
        controller_to_get(__callee__, :model_class) || Map.model_class_map(current_resources_name)
    end

    # Shorthand of params[:id]
    # @return [String, nil] ID param
    def resource_id
      params[:id]
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is a method to return collection for index page.
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def collection
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   collection! options do |query| # NOTE: this is better than using `super`
    #     # NOTE: make sure a collection is returned
    #     query.where(active: true)
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def collection
    #   # NOTE: pagination should happen here if needed
    #   # NOTE: make sure `@collection` and conditional assignment (the OR EQUAL) operator are used
    #   @collection ||= paginate Product.active
    # end
    # ```
    # @param options [Hash] (since 5.2.0)
    # @option options [ActionController::Parameters, Hash] :params parameters for collection query
    # @option options [Boolean] :paginate see {Wallaby::Paginatable#paginate}
    # @yield [collection] (since 5.2.0) a block to run to extend collection, e.g. call chain with more queries
    # @return [#each] a collection of records
    def collection(options = {}, &block)
      @collection ||=
        ModuleUtils.yield_for(
          begin
            options[:paginate] = true unless options.key?(:paginate)
            options[:params] ||= params
            paginate current_servicer.collection(options.delete(:params)), options
          end,
          &block
        )
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is a method to return resource for pages except `index`.
    #
    # `WARN: It does not do mass assignment since 5.2.0.`
    #
    # It can be customized as below in subclasses:
    #
    # ```
    # def resource
    #   # do something before the origin action
    #   options = {} # NOTE: see `options` parameter for more details
    #   resource! options do |object| # NOTE: this is better than using `super`
    #     object.preload_status_from_api
    #     # NOTE: make sure object is returned
    #     object
    #   end
    # end
    # ```
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # ```
    # def resource
    #   # NOTE: make sure `@resource` and conditional assignment (the OR EQUAL) operator are used
    #   @resource ||= resource_id.present? ? Product.find_by_slug(resource_id) : Product.new(arrival: true)
    # end
    # ```
    # @param options [Hash] (since 5.2.0)
    # @option options [Array<String>] :non_find_actions action names that shouldn't use resource find.
    #   (Default to `%w(index new create)`)
    # @option options [ActionController::Parameters, Hash] :find_params parameters/options for resource finding
    # @option options [ActionController::Parameters, Hash] :new_params parameters/options for new resource
    # @yield [resource] (since 5.2.0) a block to run to extend resource, e.g. making change to the resource.
    #   Please make sure to return the resource at the end of block
    # @return [Object] either persisted or unpersisted resource instance
    # @raise [ResourceNotFound] if resource is nil
    def resource(options = {}, &block)
      @resource ||=
        ModuleUtils.yield_for(
          # this will testify both resource and resources
          if resource_id.present? || !(options[:non_find_actions] || NON_FIND_ACTIONS).include?(action_name)
            current_servicer.find resource_id, options[:find_params]
          else
            current_servicer.new options[:new_params]
          end,
          &block
        )
    end
  end
end

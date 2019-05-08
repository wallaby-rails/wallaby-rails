module Wallaby
  # Servicer related attributes
  module Servicable
    # Configurable attribute
    module ClassMethods
      # @!attribute [w] model_servicer
      def model_servicer=(model_servicer)
        ModuleUtils.inheritance_check model_servicer, application_servicer
        @model_servicer = model_servicer
      end

      # @!attribute [r] model_servicer
      # If Wallaby doesn't get it right, please specify the **model_servicer**.
      # @example To set model servicer
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_servicer = ProductServicer
      #   end
      # @return [Class] model servicer
      # @raise [ArgumentError] when **model_servicer** doesn't inherit from **application_servicer**
      # @see Wallaby::ModelServicer
      # @since 5.2.0
      attr_reader :model_servicer

      # @!attribute [w] application_servicer
      def application_servicer=(application_servicer)
        ModuleUtils.inheritance_check model_servicer, application_servicer
        @application_servicer = application_servicer
      end

      # @!attribute [r] application_servicer
      # The **application_servicer** is as the base class of {#model_servicer}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_servicer = AnotherApplicationServicer
      #   end
      # @return [Class] application decorator
      # @raise [ArgumentError] when **model_servicer** doesn't inherit from **application_servicer**
      # @see Wallaby::ModelServicer
      # @since 5.2.0
      def application_servicer
        @application_servicer ||= ModuleUtils.try_to superclass, :application_servicer
      end
    end

    # Model servicer for current modal class. It comes from:
    #
    # - controller configuration {Wallaby::Servicable::ClassMethods#model_servicer .model_servicer}
    # - a generic servicer based on {Wallaby::Servicable::ClassMethods#application_servicer .application_servicer}
    # @return [Wallaby::ModelServicer] model servicer
    # @since 5.2.0
    def current_servicer
      @current_servicer ||=
        (controller_to_get(:model_servicer) \
          || Map.servicer_map(current_model_class, controller_to_get(:application_servicer))).try do |klass|
          Rails.logger.info %(  - Current servicer: #{klass})
          klass.new current_model_class, current_authorizer, current_model_decorator
        end
    end

    # @deprecated Use {#current_servicer} instead. It will be removed from 5.3.*
    def current_model_service
      Utils.deprecate 'deprecation.current_model_service', caller: caller
      current_servicer
    end
  end
end

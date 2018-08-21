module Wallaby
  # Authorizer related attributes
  module Authorizable
    # Configurable attribute
    module ClassMethods
      # @!attribute [w] model_authorizer
      def model_authorizer=(model_authorizer)
        ModuleUtils.inheritance_check model_authorizer, application_authorizer
        @model_authorizer = model_authorizer
      end

      # @!attribute [r] model_authorizer
      # If Wallaby doesn't get it right, please specify the **model_authorizer**.
      # @example To set model authorizer
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_authorizer = ProductAuthorizer
      #   end
      # @raise [ArgumentError] when **model_authorizer** doesn't inherit from **application_authorizer**
      # @see Wallaby::ModelAuthorizer
      # @return [Class] model authorizer
      # @since 5.2.0
      attr_reader :model_authorizer

      # @!attribute [w] application_authorizer
      # @raise [ArgumentError] when **model_authorizer** doesn't inherit from **application_authorizer**
      def application_authorizer=(application_authorizer)
        ModuleUtils.inheritance_check model_authorizer, application_authorizer
        @application_authorizer = application_authorizer
      end

      # @!attribute [r] application_authorizer
      # The **application_authorizer** is as the base class of {#model_authorizer}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_authorizer = AnotherApplicationAuthorizer
      #   end
      # @since 5.2.0
      # @see Wallaby::ModelAuthorizer
      # @return [Class] application decorator
      def application_authorizer
        @application_authorizer ||= Utils.try_to superclass, :application_authorizer
      end
    end

    # Model authorizer for current modal class. It comes from:
    #
    # - controller configuration {Wallaby::Servicable::ClassMethods#model_authorizer .model_authorizer}
    # - a generic authorizer based on {Wallaby::Servicable::ClassMethods#application_authorizer .application_authorizer}
    # @return [Wallaby::ModelAuthorizer] model authorizer
    def current_authorizer
      @current_authorizer ||= begin
        klass =
          controller_to_get(__callee__, :model_authorizer) \
            || Map.authorizer_map(current_model_class, controller_to_get(:application_authorizer))
        klass.new self, current_model_class
      end
    end

    def authorizer_of(model_class)
      klass = Map.authorizer_map(model_class, controller_to_get(:application_authorizer))
      klass.new self, model_class
    end

    # @deprecated Use {#current_authorizer} instead. It will be removed from 5.3.*
    # @return [Wallaby::ModelAuthorizer] model authorizer
    def authorizer
      Utils.deprecate 'deprecation.authorizer', caller: caller
      current_authorizer
    end

    def authorized?(action, subject)
      raise ArgumentError, I18n.t('errors.required', subject: 'subject') unless subject
      klass = subject.is_a?(Class) ? subject : subject.class
      authorizer_of(klass).authorized? action, subject
    end

    def unauthorized?(action, subject)
      !authorized? action, subject
    end
  end
end

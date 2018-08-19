module Wallaby
  # Paginator related attributes
  module Paginatable
    # Configurable attribute
    module ClassMethods
      # @!attribute [w] model_paginator
      def model_paginator=(model_paginator)
        ModuleUtils.inheritance_check model_paginator, application_paginator
        @model_paginator = model_paginator
      end

      # @!attribute [r] model_paginator
      # If Wallaby doesn't get it right, please specify the **model_paginator**.
      # @example To set model paginator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_paginator = ProductPaginator
      #   end
      # @raise [ArgumentError] when **model_paginator** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelPaginator
      # @return [Class] model paginator
      # @since 5.2.0
      attr_reader :model_paginator

      # @!attribute [w] application_paginator
      # @raise [ArgumentError] when **model_paginator** doesn't inherit from **application_paginator**
      def application_paginator=(application_paginator)
        ModuleUtils.inheritance_check model_paginator, application_paginator
        @application_paginator = application_paginator
      end

      # @!attribute [r] application_paginator
      # The **application_paginator** is as the base class of {#model_paginator}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_paginator = AnotherApplicationPaginator
      #   end
      # @since 5.2.0
      # @see Wallaby::ModelPaginator
      # @return [Class] application decorator
      def application_paginator
        @application_paginator ||= Utils.try_to superclass, :application_paginator
      end
    end

    # Resource paginator for current modal class. It comes from:
    #
    # - controller configuration {Wallaby::Servicable::ClassMethods#model_paginator .model_paginator}
    # - a generic paginator based on {Wallaby::Servicable::ClassMethods#application_paginator .application_paginator}
    # @return [Class] model paginator
    def current_paginator_class
      @current_paginator_class ||=
        controller_to_get(__callee__, :model_paginator) \
          || Map.paginator_map(current_model_class, controller_to_get(:application_paginator))
    end
  end
end

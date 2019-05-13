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
      # @return [Class] model paginator
      # @raise [ArgumentError] when **model_paginator** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelPaginator
      # @since 5.2.0
      attr_reader :model_paginator

      # @!attribute [w] application_paginator
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
      # @return [Class] application decorator
      # @raise [ArgumentError] when **model_paginator** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelPaginator
      # @since 5.2.0
      def application_paginator
        @application_paginator ||= ModuleUtils.try_to superclass, :application_paginator
      end
    end

    # Model paginator for current modal class. It comes from:
    #
    # - controller configuration {Wallaby::Paginatable::ClassMethods#model_paginator .model_paginator}
    # - a generic paginator based on {Wallaby::Paginatable::ClassMethods#application_paginator .application_paginator}
    # @return [Class] model paginator class
    def current_paginator
      @current_paginator ||=
        (controller_to_get(:model_paginator) \
          || Map.paginator_map(current_model_class, controller_to_get(:application_paginator))).try do |klass|
          Rails.logger.info %(  - Current paginator: #{klass})
          klass.new current_model_class, collection, params
        end
    end

    # To paginate the collection but only when either `page` or `per` param is given,
    # or HTML response is requested
    # @param query [#each]
    # @param options [Hash]
    # @option options [Boolean] :paginate whether collection should be paginated
    # @return [#each]
    # @see Wallaby::ModelServicer#paginate
    def paginate(query, options)
      options[:paginate] ? current_servicer.paginate(query, params) : query
    end
  end
end

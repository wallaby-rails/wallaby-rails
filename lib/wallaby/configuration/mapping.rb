module Wallaby
  class Configuration
    # Configuration used in {Wallaby::Map}
    # @since 5.1.6
    class Mapping
      # @!attribute [w] resources_controller
      attr_writer :resources_controller

      # @!attribute [r] resources_controller
      # @since 5.1.6
      # To globally configure the resources controller.
      #
      # If no configuration is given, Wallaby will look up the following controller classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationController (only when it inherits from {Wallaby::ResourcesController})
      # - {Wallaby::ResourcesController}
      # @example To update the resources controller to `GlobalResourcesController` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.resources_controller = ::GlobalResourcesController
      #   end
      # @return [Class] resources controller class
      def resources_controller
        @resources_controller ||=
          defined?(::Admin::ApplicationController) \
            && ::Admin::ApplicationController < ::Wallaby::ResourcesController \
            && ::Admin::ApplicationController
        @resources_controller ||= ResourcesController
      end

      # @!attribute [w] resource_decorator
      attr_writer :resource_decorator

      # @!attribute [r] resource_decorator
      # @since 5.1.6
      # To globally configure the resource decorator.
      #
      # If no configuration is given, Wallaby will look up the following decorator classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationDecorator (only when it inherits from {Wallaby::ResourceDecorator})
      # - {Wallaby::ResourceDecorator}
      # @example To update the resource decorator to `GlobalResourceDecorator` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.resource_decorator = ::GlobalResourceDecorator
      #   end
      # @return [Class] resource decorator class
      def resource_decorator
        @resource_decorator ||=
          defined?(::Admin::ApplicationDecorator) \
            && ::Admin::ApplicationDecorator < ::Wallaby::ResourceDecorator \
            && ::Admin::ApplicationDecorator
        @resource_decorator ||= ResourceDecorator
      end

      # @!attribute [w] model_servicer
      attr_writer :model_servicer

      # @!attribute [r] model_servicer
      # @since 5.1.6
      # To globally configure the model servicer.
      #
      # If no configuration is given, Wallaby will look up the following servicer classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationServicer (only when it inherits from {Wallaby::ModelServicer})
      # - {Wallaby::ModelServicer}
      # @example To update the model servicer to `GlobalModelServicer` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.model_servicer = ::GlobalModelServicer
      #   end
      # @return [Class] model servicer class
      def model_servicer
        @model_servicer ||=
          defined?(::Admin::ApplicationServicer) \
            && ::Admin::ApplicationServicer < ::Wallaby::ModelServicer \
            && ::Admin::ApplicationServicer
        @model_servicer ||= ModelServicer
      end

      # @!attribute [w] resource_paginator
      attr_writer :resource_paginator

      # @!attribute [r] resource_paginator
      # @since 5.1.6
      # To globally configure the resource paginator.
      #
      # If no configuration is given, Wallaby will look up the following paginator classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationServicer (only when it inherits from {Wallaby::ResourcePaginator})
      # - {Wallaby::ResourcePaginator}
      # @example To update the resource paginator to `GlobalResourcePaginator` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.resource_paginator = ::GlobalResourcePaginator
      #   end
      # @return [Class] resource paginator class
      def resource_paginator
        @resource_paginator ||=
          defined?(::Admin::ApplicationPaginator) \
            && ::Admin::ApplicationPaginator < ::Wallaby::ResourcePaginator \
            && ::Admin::ApplicationPaginator
        @resource_paginator ||= ResourcePaginator
      end

      # @!attribute [w] model_authorizer
      attr_writer :model_authorizer

      # @!attribute [r] model_authorizer
      # @since 5.1.6
      # To globally configure the model authorizer.
      #
      # If no configuration is given, Wallaby will look up the following authorizer classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationServicer (only when it inherits from {Wallaby::ModelAuthorizer})
      # - {Wallaby::ModelAuthorizer}
      # @example To update the model authorizer to `GlobalModelAuthorizer` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.model_authorizer = ::GlobalModelAuthorizer
      #   end
      # @return [Class] model authorizer class
      def model_authorizer
        @model_authorizer ||=
          defined?(::Admin::ApplicationAuthorizer) \
            && ::Admin::ApplicationAuthorizer < ::Wallaby::ModelAuthorizer \
            && ::Admin::ApplicationAuthorizer
        @model_authorizer ||= ModelAuthorizer
      end
    end
  end
end

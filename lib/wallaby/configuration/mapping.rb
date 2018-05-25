module Wallaby
  class Configuration
    # Configuration used in Wallaby::Map
    class Mapping
      attr_writer \
        :resources_controller, :resource_decorator,
        :resource_paginator, :model_servicer, :model_authorizer

      # This configuration is used by `Wallaby::Map.controller_map`
      #
      # If `resources_controller` is not defined,
      # it will fallback to `Admin::ApplicationController`,
      # otherwise `Wallaby::ResourcesController`.
      # @return [Class] configurable resources controller
      def resources_controller
        @resources_controller ||=
          defined?(::Admin::ApplicationController) \
            && ::Admin::ApplicationController < ::Wallaby::ResourcesController \
            && ::Admin::ApplicationController
        @resources_controller ||= ResourcesController
      end

      # This configuration is used by `Wallaby::Map.resource_decorator_map`
      #
      # If `resource_decorator` is not defined,
      # it will fallback to `Admin::ApplicationDecorator`,
      # otherwise `Wallaby::ResourcesDecorator`.
      # @return [Class] configurable resource decorator
      def resource_decorator
        @resource_decorator ||=
          defined?(::Admin::ApplicationDecorator) \
            && ::Admin::ApplicationDecorator < ::Wallaby::ResourceDecorator \
            && ::Admin::ApplicationDecorator
        @resource_decorator ||= ResourceDecorator
      end

      # This configuration is used by `Wallaby::Map.servicer_map`
      #
      # If model_servicer is not defined,
      # it will fallback to `Admin::ApplicationServicer`,
      # otherwise `Wallaby::ResourcesServicer`.
      # @return [Class] configurable model servicer
      def model_servicer
        @model_servicer ||=
          defined?(::Admin::ApplicationServicer) \
            && ::Admin::ApplicationServicer < ::Wallaby::ModelServicer \
            && ::Admin::ApplicationServicer
        @model_servicer ||= ModelServicer
      end

      # This configuration is used by `Wallaby::Map.paginator_map`
      #
      # If resource_paginator is not defined,
      # it will fallback to `Admin::ApplicationPaginator`,
      # otherwise `Wallaby::ResourcesPaginator`.
      # @return [Class] configurable resource paginator
      def resource_paginator
        @resource_paginator ||=
          defined?(::Admin::ApplicationPaginator) \
            && ::Admin::ApplicationPaginator < ::Wallaby::ResourcePaginator \
            && ::Admin::ApplicationPaginator
        @resource_paginator ||= ResourcePaginator
      end

      # This configuration is used by `Wallaby::Map.authorizer_map`
      #
      # If model_authorizer is not defined,
      # it will fallback to `Admin::ApplicationAuthorizer`,
      # otherwise `Wallaby::ModelAuthroizer`.
      # @return [Class] configurable model authorizer
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

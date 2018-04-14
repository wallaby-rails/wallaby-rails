module Wallaby
  class Configuration
    # Configuration used in Wallaby::Map
    class Mapping
      attr_writer \
        :resources_controller, :resource_decorator,
        :resource_paginator, :model_servicer

      # This configuration is used by `Wallaby::Map.controller_map`
      #
      # If `resources_controller` is not defined,
      # it will fallback to `Admin::ApplicationController`,
      # then `Wallaby::ResourcesController`.
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
      # then `Wallaby::ResourcesDecorator`.
      # @return [Class] configurable resource decorator
      def resource_decorator
        @resource_decorator ||=
          defined?(::Admin::ApplicationDecorator) \
            && ::Admin::ApplicationDecorator < ::Wallaby::ResourceDecorator \
            && ::Admin::ApplicationDecorator
        @resource_decorator ||= ResourceDecorator
      end

      # This configuration is used by `Wallaby::Map.paginator_map`
      #
      # If resource_paginator is not defined,
      # it will fallback to `Admin::ApplicationPaginator`,
      # then `Wallaby::ResourcesPaginator`.
      # @return [Class] configurable resource paginator
      def resource_paginator
        @resource_paginator ||=
          defined?(::Admin::ApplicationPaginator) \
            && ::Admin::ApplicationPaginator < ::Wallaby::ResourcePaginator \
            && ::Admin::ApplicationPaginator
        @resource_paginator ||= ResourcePaginator
      end

      # This configuration is used by `Wallaby::Map.servicer_map`
      #
      # If model_servicer is not defined,
      # it will fallback to `Admin::ApplicationServicer`,
      # then `Wallaby::ResourcesServicer`.
      # @return [Class] configurable model servicer
      def model_servicer
        @model_servicer ||=
          defined?(::Admin::ApplicationServicer) \
            && ::Admin::ApplicationServicer < ::Wallaby::ModelServicer \
            && ::Admin::ApplicationServicer
        @model_servicer ||= ModelServicer
      end
    end
  end
end

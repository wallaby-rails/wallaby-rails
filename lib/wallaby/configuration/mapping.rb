module Wallaby
  class Configuration
    # Configuration used in Wallaby::Map
    class Mapping
      attr_writer \
        :resources_controller, :resource_decorator,
        :resource_paginator, :model_servicer

      # @return [Class] configurable resources controller
      def resources_controller
        @resources_controller ||= existing_admin_application_controller
        @resources_controller ||= ResourcesController
      end

      # @return [Class] configurable resource decorator
      def resource_decorator
        @resource_decorator ||= ResourceDecorator
      end

      # @return [Class] configurable model servicer
      def resource_paginator
        @resource_paginator ||= ResourcePaginator
      end

      # @return [Class] configurable model servicer
      def model_servicer
        @model_servicer ||= ModelServicer
      end

      private

      def existing_admin_application_controller
        defined?(::Admin::ApplicationController) \
          && ::Admin::ApplicationController < ResourcesController \
          && ::Admin::ApplicationController
      end
    end
  end
end

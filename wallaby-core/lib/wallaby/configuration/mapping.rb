# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    class Mapping
      include Classifier

      # @deprecated
      def resources_controller=(_resources_controller)
        Deprecator.alert 'config.mapping.resources_controller=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set #resources_controller= from the config instead, for example:

            Wallaby.config do |config|
              config.resources_controller = ::GlobalResourcesController
            end
        INSTRUCTION
      end

      # @deprecated
      def resources_controller
        Deprecator.alert 'config.mapping.resources_controller', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use config.resources_controller instead.
        INSTRUCTION
      end

      # @deprecated
      def resource_decorator=(_resource_decorator)
        Deprecator.alert 'config.mapping.resource_decorator=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set .application_decorator= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_decorator = ::GlobalModelDecorator
            end
        INSTRUCTION
      end

      # @deprecated
      def resource_decorator
        Deprecator.alert 'config.mapping.resource_decorator', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.application_decorator.
        INSTRUCTION
      end

      # @deprecated
      def model_servicer=(_model_servicer)
        Deprecator.alert 'config.mapping.model_servicer=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set .application_servicer= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_servicer = ::GlobalModelServicer
            end
        INSTRUCTION
      end

      # @deprecated
      def model_servicer
        Deprecator.alert 'config.mapping.model_servicer', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.application_servicer.
        INSTRUCTION
      end

      # @deprecated
      def model_authorizer=(_model_authorizer)
        Deprecator.alert 'config.mapping.model_authorizer=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set .application_authorizer= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_authorizer = ::GlobalModelAuthorizer
            end
        INSTRUCTION
      end

      # @deprecated
      def model_authorizer
        Deprecator.alert 'config.mapping.model_authorizer', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.application_authorizer.
        INSTRUCTION
      end

      # @deprecated
      def model_paginator=(_model_paginator)
        Deprecator.alert 'config.mapping.model_paginator=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please set .application_paginator= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_paginator = ::GlobalModelPaginator
            end
        INSTRUCTION
      end

      # @deprecated
      def model_paginator
        Deprecator.alert 'config.mapping.model_paginator', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.application_paginator.
        INSTRUCTION
      end
    end
  end
end

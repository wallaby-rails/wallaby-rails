# frozen_string_literal: true

module Wallaby
  # Configurable related
  module Configurable
    extend ActiveSupport::Concern

    # Engine configurables
    module ClassMethods
      # @!attribute [w] engine_name
      attr_writer :engine_name

      # @!attribute [r] engine_name
      # It is used to help with URLs handling (see {Engine})
      #
      # So when to set this engine name?
      # When {Wallaby} doesn't know what is the correct engine helper to use for current path.
      # @example To set an engine name:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.engine_name = 'admin_engine'
      #   end
      # @return [String, Symbol, nil] engine name
      # @since wallaby-5.2.0
      def engine_name
        @engine_name || superclass.try(:engine_name)
      end
    end

    # Controller configurables
    module ClassMethods
      # @!attribute [r] application_controller
      # @return [Class] application controller class
      def application_controller
        return self if base_class?

        superclass.try(:application_controller) || ResourcesController
      end
    end

    # Decorator configurables
    module ClassMethods
      # @!attribute [w] resource_decorator
      attr_writer :resource_decorator

      # @!attribute [r] resource_decorator
      # @example To set resource decorator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.resource_decorator = ProductDecorator
      #   end
      # @return [Class] resource decorator
      # @see ResourceDecorator
      # @since wallaby-5.2.0
      def resource_decorator
        @resource_decorator ||= Guesser.class_for(name, suffix: DECORATOR, &:model_class)
      end

      # @!attribute [w] application_decorator
      attr_writer :application_decorator

      # @!attribute [r] application_decorator
      # It is the base class of {#resource_decorator}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_decorator = AnotherApplicationDecorator
      #   end
      # @return [Class] application decorator
      # @see ResourceDecorator
      # @since wallaby-5.2.0
      def application_decorator
        @application_decorator ||= Guesser.class_for(name, suffix: DECORATOR, &:base_class?)
        @application_decorator || superclass.try(:application_decorator) || ResourceDecorator
      end
    end

    # Servicer configurables
    module ClassMethods
      # @!attribute [w] model_servicer
      attr_writer :model_servicer

      # @!attribute [r] model_servicer
      # @example To set model servicer
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_servicer = ProductServicer
      #   end
      # @return [Class] model servicer
      # @see ModelServicer
      # @since wallaby-5.2.0
      def model_servicer
        @model_servicer ||= Guesser.class_for(name, suffix: SERVICER, &:model_class)
      end

      # @!attribute [w] application_servicer
      attr_writer :application_servicer

      # @!attribute [r] application_servicer
      # It is the base class of {#model_servicer}.
      # @example To set application servicer:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_servicer = AnotherApplicationServicer
      #   end
      # @return [Class] application servicer
      # @see ModelServicer
      # @since wallaby-5.2.0
      def application_servicer
        @application_servicer ||= Guesser.class_for(name, suffix: SERVICER, &:base_class?)
        @application_servicer || superclass.try(:application_servicer) || ModelServicer
      end
    end

    # Authorizer configurables
    module ClassMethods
      # @!attribute [w] model_authorizer
      attr_writer :model_authorizer

      # @!attribute [r] model_authorizer
      # @example To set model authorizer
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_authorizer = ProductAuthorizer
      #   end
      # @return [Class] model authorizer
      # @see ModelAuthorizer
      # @since wallaby-5.2.0
      def model_authorizer
        @model_authorizer ||= Guesser.class_for(name, suffix: AUTHORIZER, &:model_class)
      end

      # @!attribute [w] application_authorizer
      attr_writer :application_authorizer

      # @!attribute [r] application_authorizer
      # It is the base class of {#model_authorizer}.
      # @example To set application authorizer:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_authorizer = AnotherApplicationAuthorizer
      #   end
      # @return [Class] application authorizer
      # @see ModelAuthorizer
      # @since wallaby-5.2.0
      def application_authorizer
        @application_authorizer ||= Guesser.class_for(name, suffix: AUTHORIZER, &:base_class?)
        @application_authorizer || superclass.try(:application_authorizer) || ModelAuthorizer
      end
    end

    # Paginator configurables
    module ClassMethods
      # @!attribute [w] model_paginator
      attr_writer :model_paginator

      # @!attribute [r] model_paginator
      # @example To set model paginator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_paginator = ProductPaginator
      #   end
      # @return [Class] model paginator
      # @see ModelPaginator
      # @since wallaby-5.2.0
      def model_paginator
        @model_paginator ||= Guesser.class_for(name, suffix: PAGINATOR, &:model_class)
      end

      # @!attribute [w] application_paginator
      attr_writer :application_paginator

      # @!attribute [r] application_paginator
      # It is the base class of {#model_paginator}.
      # @example To set application paginator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_paginator = AnotherApplicationPaginator
      #   end
      # @return [Class] application paginator
      # @see ModelPaginator
      # @since wallaby-5.2.0
      def application_paginator
        @application_paginator ||= Guesser.class_for(name, suffix: PAGINATOR, &:base_class?)
        @application_paginator || superclass.try(:application_paginator) || ModelPaginator
      end
    end

    # Models configurables
    module ClassMethods
      # @!attribute [r] models
      # To configure the models that the controller should be handling.
      # It takes both Class and Class String.
      # @example To update the models in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.models = User, 'Product'
      #   end
      # @since 0.2.3
      def models
        @models || superclass.try(:models) || ClassArray.new
      end

      # @!attribute [w] models
      def models=(*models)
        @models = ClassArray.new models.flatten
      end

      # @note If models are allowlisted using {#models}, models exclusion will NOT be applied.
      # @!attribute [r] models_to_exclude
      # To configure the models to exclude that the controller should be handling.
      # It takes both Class and Class String.
      # @example To update the models to exclude in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.models_to_exclude = User, 'Product'
      #   end
      # @since 0.2.3
      def models_to_exclude
        @models_to_exclude ||
          superclass.try(:models_to_exclude) ||
          DefaultModelsExcluder.execute
      end

      # @!attribute [w] models_to_exclude
      def models_to_exclude=(*models_to_exclude)
        @models_to_exclude = ClassArray.new models_to_exclude.flatten
      end

      # @return [Array<Class>] all models
      def all_models
        ModelClassFilter.execute(
          all: Map.mode_map.keys,
          allowlisted: models.origin,
          denylisted: models_to_exclude.origin
        )
      end
    end

    # Authentication configurables
    module ClassMethods
      # @!attribute [r] logout_path
      # To configure the logout path.
      #
      # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout path will be required
      # so that Wallaby knows where to navigate the user to when user clicks the logout button.
      #
      # But once it detects `Devise`, it will use the path that Devise uses without the need of configuration.
      # @example To update the logout path in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.logout_path = 'destroy_admin_user_session_path'
      #   end
      # @since 0.2.3
      def logout_path
        @logout_path || superclass.try(:logout_path)
      end

      # @!attribute [w] logout_path
      def logout_path=(logout_path)
        case logout_path
        when String, Symbol, nil
          @logout_path = logout_path
        else
          raise ArgumentError, 'Please provide a String/Symbol value or nil'
        end
      end

      # @!attribute [r] logout_method
      # To configure the logout HTTP method.
      #
      # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout method will be required
      # so that Wallaby knows how navigate the user via what HTTP method when user clicks the logout button.
      #
      # But once it detects `Devise`, it will use the HTTP method that Devise uses without the need of configuration.
      # @example To update the logout method in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.logout_method = 'put'
      #   end
      # @since 0.2.3
      def logout_method
        @logout_method || superclass.try(:logout_method)
      end

      # @!attribute [w] logout_method
      def logout_method=(logout_method)
        normalized = logout_method.present? ? logout_method.to_s.downcase : nil
        rfc2616 = ActionDispatch::Request::RFC2616.map(&:downcase)

        if normalized.nil? || rfc2616.include?(normalized)
          @logout_method = logout_method
          return
        end

        raise ArgumentError, "Please provide valid RFC2616 HTTP method (e.g. #{rfc2616.join(', ')}) or nil"
      end

      # @!attribute [r] email_method
      # To configure the method on
      # {AuthenticationConcern#wallaby_user} to retrieve email address.
      #
      # If no configuration is given, it will attempt to call `email` on
      # {AuthenticationConcern#wallaby_user}.
      # @example To update the email method in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.email_method = 'email_address'
      #   end
      # @since 0.2.3
      def email_method
        @email_method || superclass.try(:email_method)
      end

      # @!attribute [w] email_method
      def email_method=(email_method)
        case email_method
        when String, Symbol, nil
          @email_method = email_method
        else
          raise ArgumentError, 'Please provide a String/Symbol value or nil'
        end
      end
    end

    # Metadata configurables
    module ClassMethods
      # @!attribute [r] max_text_length
      # To configure max number of characters to truncate for each text field on index page.
      # @example To update the email method in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.max_text_length = 50
      #   end
      # @return [Integer] max number of characters to truncate, default to 20
      # @see DEFAULT_MAX
      # @since 0.2.3
      def max_text_length
        @max_text_length || superclass.try(:max_text_length) || DEFAULT_MAX
      end

      # @!attribute [w] max_text_length
      def max_text_length=(max_text_length)
        case max_text_length
        when Integer, nil
          @max_text_length = max_text_length
        else
          raise ArgumentError, 'Please provide a Integer value or nil'
        end
      end
    end

    # Pagination configurables
    module ClassMethods
      # @!attribute [r] page_size
      # To configure the page size for pagination on index page.
      #
      # Page size can be one of the following values:
      #
      # - 10
      # - 20
      # - 50
      # - 100
      # @example To update the email method in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.page_size = 50
      #   end
      # @return [Integer] page size, default to 20
      # @see PERS
      # @see DEFAULT_PAGE_SIZE
      # @since 0.2.3
      def page_size
        @page_size || superclass.try(:page_size) || DEFAULT_PAGE_SIZE
      end

      # @!attribute [w] page_size
      def page_size=(page_size)
        case page_size
        when Integer, nil
          @page_size = page_size
        else
          raise ArgumentError, 'Please provide a Integer value or nil'
        end
      end
    end

    # Sorting configurables
    module ClassMethods
      # @!attribute [r] sorting_strategy
      # To configure which strategy to use for sorting on index page. Options are
      #
      #   - `:multiple`: support multiple columns sorting
      #   - `:single`: support single column sorting
      # @example To update the email method in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.sorting_strategy = :single
      #   end
      # @return [Integer] sorting strategy, default to `:multiple`
      # @see PERS
      # @since 0.2.3
      def sorting_strategy
        @sorting_strategy || superclass.try(:sorting_strategy) || :multiple
      end

      # @!attribute [w] sorting_strategy
      def sorting_strategy=(sorting_strategy)
        case sorting_strategy
        when :multiple, :single, nil
          @sorting_strategy = sorting_strategy
        else
          raise ArgumentError, 'Please provide a value of :multiple, :single or nil'
        end
      end
    end

    # Clear configurables
    module ClassMethods
      # Clear all configurations
      def clear
        ClassMethods.instance_methods.grep(/=/).each do |name|
          instance_variable_set :"@#{name[0...-1]}", nil
        end
      end
    end

    # @return [Class] its controller class
    def wallaby_controller
      @wallaby_controller ||= try(:controller).try(:class) || self.class
    end
  end
end

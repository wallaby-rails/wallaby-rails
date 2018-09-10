module Wallaby
  # This controller only contains authentication logics.
  class SecureController < ::Wallaby::ApplicationController
    helper SecureHelper
    helper_method :current_user

    rescue_from NotAuthenticated, with: :unauthorized
    rescue_from Unauthorized, with: :forbidden

    # Unauthorized page. And it will be used for error handling as the action name implies.
    # @param exception [Exception] exception comes from `rescue_from`
    def unauthorized(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Forbidden page. And it will be used for error handling as the action name implies.
    # @param exception [Exception] exception comes from `rescue_from`
    def forbidden(exception = nil)
      error_rendering(exception, __callee__)
    end

    # This `current_user` method will try to looking up the actual implementation from the following
    # places from high precedence to low:
    #
    # - {Wallaby::Configuration::Security#current_user}
    # - `super` method
    # - do nothing
    # @note This is a template method that can be overridden by subclasses
    # @see https://www.rubydoc.info/gems/devise/Devise%2FControllers%2FHelpers.define_helpers
    #   Devise::Controllers::Helpers#define_helpers
    # @return [Object] a user object
    def current_user
      @current_user ||=
        if security.current_user? || !defined? super
          instance_exec(&security.current_user)
        else
          super
        end
    end

    # This `authenticate_user!` method will try to looking up the actual implementation from the following
    # places from high precedence to low:
    #
    # - {Wallaby::Configuration::Security#authenticate}
    # - super
    # - do nothing
    # @note This is a template method that can be overridden by subclasses
    # @see https://www.rubydoc.info/gems/devise/Devise%2FControllers%2FHelpers.define_helpers
    #   Devise::Controllers::Helpers#define_helpers
    def authenticate_user!
      authenticated =
        if security.authenticate? || !defined? super
          instance_exec(&security.authenticate)
        else
          super
        end
      raise NotAuthenticated unless authenticated
      true
    end
  end
end

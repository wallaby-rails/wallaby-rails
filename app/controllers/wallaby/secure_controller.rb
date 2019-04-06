module Wallaby
  # This is the controller with only authentication logics.
  class SecureController < ::Wallaby::ApplicationController
    helper SecureHelper
    helper_method :current_user

    rescue_from NotAuthenticated, with: :unauthorized
    rescue_from Forbidden, with: :forbidden

    # Unauthorized page.
    # @param exception [Exception] exception comes from `rescue_from`
    def unauthorized(exception = nil)
      error_rendering exception, __callee__
    end

    # Forbidden page.
    # @param exception [Exception] exception comes from `rescue_from`
    def forbidden(exception = nil)
      error_rendering exception, __callee__
    end

    # @note This is a template method that can be overridden by subclasses
    # This {current_user} method will try to looking up the actual implementation from the following
    # places from high precedence to low:
    #
    # - {Wallaby::Configuration::Security#current_user}
    # - `super`
    # - do nothing
    #
    # It can be replaced completely in subclasses:
    #
    # ```
    # def current_user
    #   # NOTE: please ensure `@current_user` is assigned, for instance:
    #   @current_user ||= User.new params.slice(:email)
    # end
    # ```
    # @return [Object] a user object
    def current_user
      @current_user ||=
        if security.current_user? || !defined? super
          instance_exec(&security.current_user)
        else
          super
        end
    end

    # @note This is a template method that can be overridden by subclasses
    # This {authenticate_user!} method will try to looking up the actual implementation from the following
    # places from high precedence to low:
    #
    # - {Wallaby::Configuration::Security#authenticate}
    # - `super`
    # - do nothing
    #
    # It can be replaced completely in subclasses:
    #
    # ```
    # def authenticate_user!
    #   authenticate_or_request_with_http_basic do |username, password|
    #     username == 'too_simple' && password == 'too_naive'
    #   end
    # end
    # ```
    # @return [true] when user is authenticated successfully
    # @raise [Wallaby::NotAuthenticated] when user fails to authenticate
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

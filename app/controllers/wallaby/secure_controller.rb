module Wallaby
  # This controller only contains authentication logics
  class SecureController < ::Wallaby::ApplicationController
    helper SecureHelper
    helper_method :current_user

    rescue_from NotAuthenticated, with: :unauthorized
    rescue_from ::CanCan::AccessDenied, with: :forbidden

    # Unauthorized page
    def unauthorized(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Forbidden page
    def forbidden(exception = nil)
      error_rendering(exception, __callee__)
    end

    # Precedence of current_user:
    # - [Security] @see Wallaby::SecureController#security_config
    # - super
    # - do nothing
    # @see Devise::Controllers::Helpers#define_helpers
    # @return a user object
    def current_user
      @current_user ||=
      if security_config.current_user? || !defined? super
        instance_exec(&security_config.current_user)
      else
        super
      end
    end

    # @return [Wallaby::Configuration::Security] security configuration
    def security_config
      configuration.security
    end

    protected

    # Precedence of authenticate_user!:
    # - [Security] @see Wallaby::SecureController#security_config
    # - super
    # - do nothing
    # @see Devise::Controllers::Helpers#define_helpers
    def authenticate_user!
      authenticated =
        if security_config.authenticate? || !defined? super
          instance_exec(&security_config.authenticate)
        else
          super
        end
      raise NotAuthenticated unless authenticated
      true
    end
  end
end

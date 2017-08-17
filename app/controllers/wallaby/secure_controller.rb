module Wallaby
  # Responsible for authentications
  class SecureController < ApplicationController
    helper SecureHelper

    rescue_from NotAuthenticated, with: :unauthorized
    rescue_from ::CanCan::AccessDenied, with: :forbidden
    helper_method :current_user

    def unauthorized(exception = nil)
      error_rendering(exception, __callee__)
    end

    def forbidden(exception = nil)
      error_rendering(exception, __callee__)
    end

    protected

    def current_user
      @current_user ||=
        if security_config.current_user? || !defined? super
          instance_exec(&security_config.current_user)
        else
          super
        end
    end

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

    def security_config
      configuration.security
    end
  end
end

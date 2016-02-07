module Wallaby
  class SecureController < ApplicationController
    rescue_from Wallaby::NotAuthenticated, with: :access_denied
    helper_method :current_user

    protected
    def access_denied(exception)
      @exception = exception
      render 'wallaby/errors/access_denied', status: 401, layout: 'wallaby/error'
    end

    def current_user
      @current_user ||= if security_config.current_user? || !defined? super
        instance_exec &security_config.current_user
      else
        super
      end
    end

    def authenticate_user!
      authenticated = if security_config.authenticate? || !defined? super
        instance_exec &security_config.authenticate
      else
        super
      end
      fail Wallaby::NotAuthenticated if !authenticated
      true
    end

    def security_config
      Wallaby.configuration.security
    end
  end
end

module Wallaby
  class SecureController < ApplicationController
    before_action :authenticate_user!, except: [ :status ]

    helper_method :current_user

    rescue_from Wallaby::NotAuthenticated, with: :access_denied

    protected
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
    end

    def security_config
      Wallaby.configuration.security
    end

    def access_denied(exception)
      @exception = exception
      render 'wallaby/errors/access_denied', status: 401, layout: 'wallaby/error'
    end
  end
end
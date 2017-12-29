module Wallaby
  class Configuration
    # Security configuration
    class Security
      # by default, current_user returns nil
      DEFAULT_CURRENT_USER  = -> { nil }
      # by default, not to stop the before_action chain
      DEFAULT_AUTHENTICATE  = -> { true }

      # Configure how to get the current user. All application controller
      # methods will be available.
      # @example
      #   ```
      #     Wallaby.config do |c|
      #       c.security.current_user do
      #         User.find_by_email session[:user_email]
      #       end
      #     end
      #   ```
      def current_user(&block)
        if block_given?
          @current_user = block
        else
          @current_user ||= DEFAULT_CURRENT_USER
        end
      end

      # See if current_user configuration is set
      # @return [Boolean]
      def current_user?
        current_user != DEFAULT_CURRENT_USER
      end

      # Configure how to authenicate a user. All application controller
      # methods will be available.
      # @example
      #   ```
      #     Wallaby.config do |c|
      #       c.security.authenticate do
      #         authenticate_or_request_with_http_basic do |username, password|
      #           username == 'too_simple' && password == 'too_naive'
      #         end
      #       end
      #     end
      #   ```
      def authenticate(&block)
        if block_given?
          @authenticate = block
        else
          @authenticate ||= DEFAULT_AUTHENTICATE
        end
      end

      # See if authenticate configuration is set
      # @return [Boolean]
      def authenticate?
        authenticate != DEFAULT_AUTHENTICATE
      end
    end
  end
end

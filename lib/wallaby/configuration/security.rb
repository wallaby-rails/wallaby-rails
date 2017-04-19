module Wallaby
  class Configuration
    # Security configuration
    class Security
      # by default, current_user returns nil
      DEFAULT_CURRENT_USER  = -> {}
      # by default, not to stop the before_action chain
      DEFAULT_AUTHENTICATE  = -> { true }

      def current_user(&block)
        if block_given?
          @current_user = block
        else
          @current_user ||= DEFAULT_CURRENT_USER
        end
      end

      def current_user?
        current_user != DEFAULT_CURRENT_USER
      end

      def authenticate(&block)
        if block_given?
          @authenticate = block
        else
          @authenticate ||= DEFAULT_AUTHENTICATE
        end
      end

      def authenticate?
        authenticate != DEFAULT_AUTHENTICATE
      end
    end
  end
end

module Wallaby
  class Configuration
    # Security configuration
    class Security
      # Default block to return nil for current user
      DEFAULT_CURRENT_USER = -> { nil }
      # Default block to return nil
      DEFAULT_AUTHENTICATE = -> { true }

      # @!attribute logout_path
      # To globally configure the logout path.
      #
      # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout path will be required
      # so that Wallaby knows where to navigate the user to when user clicks the logout button.
      #
      # But once it detects `Devise`, it will use the path that Devise uses without the need of configuration.
      # @example To update the logout path in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.logout_path = 'logout_path'
      #   end
      # @since 5.1.4
      attr_accessor :logout_path

      # @!attribute logout_method
      # To globally configure the logout HTTP method.
      #
      # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout method will be required
      # so that Wallaby knows how navigate the user via what HTTP method when user clicks the logout button.
      #
      # But once it detects `Devise`, it will use the HTTP method that Devise uses without the need of configuration.
      # @example To update the logout method in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.logout_method = 'post'
      #   end
      # @since 5.1.4
      attr_accessor :logout_method

      # @!attribute email_method
      # To globally configure the method on {#current_user} to retrieve email address.
      #
      # If no configuration is given, it will attempt to call `email` on {#current_user}.
      # @example To update the email method in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.email_method = 'email_address'
      #   end
      # @since 5.1.4
      attr_accessor :email_method

      # To globally configure how to get user object.
      # @example To update how to get the current user object in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.current_user do
      #       User.find_by_email session[:user_email]
      #     end
      #   end
      # @yield A block to get user object. All application controller methods can be used in the block.
      def current_user(&block)
        if block_given?
          @current_user = block
        else
          @current_user ||= DEFAULT_CURRENT_USER
        end
      end

      # Check if {#current_user} configuration is set.
      # @return [Boolean]
      def current_user?
        current_user != DEFAULT_CURRENT_USER
      end

      # To globally configure how to authenicate a user.
      # @example
      #   Wallaby.config do |config|
      #     config.security.authenticate do
      #       authenticate_or_request_with_http_basic do |username, password|
      #         username == 'too_simple' && password == 'too_naive'
      #       end
      #     end
      #   end
      # @yield A block to authenticate user. All application controller methods can be used in the block.
      def authenticate(&block)
        if block_given?
          @authenticate = block
        else
          @authenticate ||= DEFAULT_AUTHENTICATE
        end
      end

      # Check if {#authenticate} configuration is set.
      # @return [Boolean]
      def authenticate?
        authenticate != DEFAULT_AUTHENTICATE
      end
    end
  end
end

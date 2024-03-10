# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    class Security
      # Default block to return nil for current user
      DEFAULT_CURRENT_USER = -> {}
      # Default block to return nil
      DEFAULT_AUTHENTICATE = -> { true }

      # @deprecated
      def logout_path
        Deprecator.alert 'config.security.logout_path', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.logout_path instead.
        INSTRUCTION
      end

      # @deprecated
      def logout_path=(_logout_path)
        Deprecator.alert 'config.security.logout_path=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use #logout_path= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.logout_path = 'destroy_admin_user_session_path'
            end
        INSTRUCTION
      end

      # @deprecated
      def logout_method
        Deprecator.alert 'config.security.logout_method', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.logout_method instead.
        INSTRUCTION
      end

      # @deprecated
      def logout_method=(_logout_method)
        Deprecator.alert 'config.security.logout_method=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use #logout_method= from the controller instead, for example:

          class Admin::ApplicationController < Wallaby::ResourcesController
            self.logout_method = 'put'
          end
        INSTRUCTION
      end

      # @deprecated
      def email_method
        Deprecator.alert 'config.security.email_method', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller_class.email_method instead.
        INSTRUCTION
      end

      # @deprecated
      def email_method=(_email_method)
        Deprecator.alert 'config.security.email_method=', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use #email_method= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.email_method = 'email_address'
            end
        INSTRUCTION
      end

      # @deprecated
      def current_user
        Deprecator.alert 'config.security.current_user', from: '0.3.0', alternative: <<~INSTRUCTION
          Please change #wallaby_user from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              def wallaby_user
                User.find_by_email session[:user_email]
              end
            end
        INSTRUCTION
      end

      # @deprecated
      def current_user?
        Deprecator.alert 'config.security.current_user?', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller#wallaby_user instead.
        INSTRUCTION
      end

      # @deprecated
      def authenticate
        Deprecator.alert 'config.security.authenticate', from: '0.3.0', alternative: <<~INSTRUCTION
          Please change #authenticate_wallaby_user! from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              def authenticate_wallaby_user!
                authenticate_or_request_with_http_basic do |username, password|
                  username == 'too_simple' && password == 'too_naive'
                end
              end
            end
        INSTRUCTION
      end

      # @deprecated
      def authenticate?
        Deprecator.alert 'config.security.authenicate?', from: '0.3.0', alternative: <<~INSTRUCTION
          Please use controller#authenticate_wallaby_user! instead.
        INSTRUCTION
      end
    end
  end
end

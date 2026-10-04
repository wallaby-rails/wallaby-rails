# frozen_string_literal: true

module Wallaby
  # Authentication related functions
  module AuthenticationConcern
    extend ActiveSupport::Concern

    included do
      try :helper_method, :wallaby_user

      rescue_from NotAuthenticated, with: :unauthorized
      rescue_from Forbidden, with: :forbidden

      # # @note This is a proxy method to ensure {#current_user} exists
      unless method_defined?(:current_user)
        def current_user
          defined?(super) ? super : nil
        end
      end
    end

    # @note This is a template method that can be overridden by subclasses
    # This method will try to call #current_user from superclass.
    # @example It can be overridden in subclasses:
    #   def wallaby_user
    #     # NOTE: better to assign user to `@wallaby_user` for better performance:
    #     @wallaby_user ||= User.new params.slice(:email)
    #   end
    # @return [Object] a user object
    def wallaby_user
      @wallaby_user ||= try :current_user
    end

    # @note This is a template method that can be overridden by subclasses
    # This method will try to call #authenticate_user! from superclass.
    # And it will be run as the first callback before an action.
    # @example It can be overridden in subclasses:
    #   def authenticate_wallaby_user!
    #     authenticate_or_request_with_http_basic do |username, password|
    #       username == 'too_simple' && password == 'too_naive'
    #     end
    #   end
    # @return [true] when user is authenticated successfully
    # @raise [NotAuthenticated] when user fails to authenticate
    def authenticate_wallaby_user!
      # NOTE: allow the base controller (e.g. the host app's ApplicationController)
      # to provide its own implementation, since this module is included after it.
      return super if defined?(super)

      # SECURITY: fail closed. If the host controller does not define
      # `authenticate_user!`, `try` returns `nil`. Treating that as success would
      # expose the whole admin interface anonymously, so only an explicit
      # truthy return value authenticates the request.
      authenticated = try :authenticate_user!
      raise NotAuthenticated unless authenticated

      true
    end

    # Unauthorized page.
    # @param exception [Exception] comes from **rescue_from**
    def unauthorized(exception = nil)
      render_error exception, __callee__
    end

    # Forbidden page.
    # @param exception [Exception] comes from **rescue_from**
    def forbidden(exception = nil)
      render_error exception, __callee__
    end
  end
end

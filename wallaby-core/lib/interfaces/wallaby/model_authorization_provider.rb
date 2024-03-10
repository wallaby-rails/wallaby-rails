# frozen_string_literal: true

module Wallaby
  # Model Authorizer interface.
  # @since wallaby-5.2.0
  class ModelAuthorizationProvider
    class << self
      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # This is the provider name (e.g. `:default`/`:cancancan`/`:pundit`)
      # that can be set in {ModelAuthorizer} subclasses's {ModelAuthorizer.provider_name}.
      # @return [String/Symbol] provider name
      def provider_name
        @provider_name ||= name.demodulize.gsub(/(Authorization)?Provider/, EMPTY_STRING).underscore
      end

      # @note Template method to check and see if current provider is in used.
      # @param _context [ActionController::Base, ActionView::Base]
      # @raise [NotImplemented]
      def available?(_context)
        raise NotImplemented
      end

      # @note Template method to get the required data from context.
      # @param _context [ActionController::Base, ActionView::Base]
      # @raise [NotImplemented]
      def options_from(_context)
        raise NotImplemented
      end
    end

    # @!attribute [r] options
    # @return [Hash]
    attr_reader :options

    # @param options [Hash]
    def initialize(options = {})
      @options = options || {}
    end

    # @return [Object, nil] user object
    def user
      options[:user]
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check user's permission for given action on given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @raise [NotImplemented]
    def authorize(_action, _subject)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has permission for given action on given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @raise [NotImplemented]
    def authorized?(_action, _subject)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has no permission for given action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [NotImplemented]
    def unauthorized?(action, subject)
      !authorized?(action, subject)
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's access to certain scope.
    # @param _action [Symbol, String]
    # @param _scope [Object]
    # @raise [NotImplemented]
    def accessible_for(_action, _scope)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's modification to certain fields of given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @raise [NotImplemented]
    def attributes_for(_action, _subject)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's mass assignment to certain fields of given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @raise [NotImplemented]
    def permit_params(_action, _subject)
      raise NotImplemented
    end
  end
end

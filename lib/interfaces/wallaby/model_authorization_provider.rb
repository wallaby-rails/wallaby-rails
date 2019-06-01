module Wallaby
  # Model Authorizer interface.
  # @since 5.2.0
  class ModelAuthorizationProvider
    class << self
      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # This is the provider name that can be set in Wallaby::ModelAuthorizer subclasses.
      # @see Wallaby::ModelAuthorizer.provider_name
      # @return [String/Symbol] provider name
      def provider_name
        @provider_name || name.demodulize.gsub(/(Authorization)?Provider/, EMPTY_STRING).underscore
      end

      # @note Template method to check and see if current provider is in used.
      # @param _context [ActionController::Base]
      # @raise [Wallaby::NotImplemented]
      def available?(_context)
        raise NotImplemented
      end

      # @note Factory method to create the authorizer instance
      # @param _context [ActionController::Base]
      # @raise [Wallaby::NotImplemented]
      def create(_context)
        raise NotImplemented
      end
    end

    # @!attribute [r] context
    # @return [ActionController::Base]
    attr_reader :context

    # @param context [ActionController::Base]
    def initialize(context)
      @context = context
    end

    # @return [Object] current user
    def user
      context.current_user
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check user's permission for given action on given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @param _options [Hash]
    # @raise [Wallaby::NotImplemented]
    def authorize(_action, _subject, _options)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has permission for given action on given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @param _options [Hash]
    # @raise [Wallaby::NotImplemented]
    def authorized?(_action, _subject, _options)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has no permission for given action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @param options [Hash]
    # @raise [Wallaby::NotImplemented]
    def unauthorized?(action, subject, options)
      !authorized?(action, subject, options)
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's access to certain scope.
    # @param _action [Symbol, String]
    # @param _scope [Object]
    # @param _options [Hash]
    # @raise [Wallaby::NotImplemented]
    def accessible_for(_action, _scope, _options)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's modification to certain fields of given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @param _options [Hash]
    # @raise [Wallaby::NotImplemented]
    def attributes_for(_action, _subject, _options)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's mass assignment to certain fields of given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @param _options [Hash]
    # @raise [Wallaby::NotImplemented]
    def permit_params(_action, _subject, _options)
      raise NotImplemented
    end
  end
end

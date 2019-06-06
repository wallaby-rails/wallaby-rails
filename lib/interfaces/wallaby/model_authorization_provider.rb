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

      # @note Template method to pull out the args required for contruction from context.
      # @param _context [ActionController::Base]
      # @raise [Wallaby::NotImplemented]
      def args_from(_context)
        raise NotImplemented
      end
    end

    # @!attribute [r] context
    # @return [ActionController::Base]
    attr_reader :context

    # @!attribute [r] user
    # @return [Object]
    attr_reader :user

    # Empty initialize that accepts all sorts of args
    def initialize(*); end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check user's permission for given action on given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @raise [Wallaby::NotImplemented]
    def authorize(_action, _subject)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has permission for given action on given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @raise [Wallaby::NotImplemented]
    def authorized?(_action, _subject)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has no permission for given action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::NotImplemented]
    def unauthorized?(action, subject)
      !authorized?(action, subject)
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's access to certain scope.
    # @param _action [Symbol, String]
    # @param _scope [Object]
    # @raise [Wallaby::NotImplemented]
    def accessible_for(_action, _scope)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's modification to certain fields of given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @raise [Wallaby::NotImplemented]
    def attributes_for(_action, _subject)
      raise NotImplemented
    end

    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's mass assignment to certain fields of given subject.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @raise [Wallaby::NotImplemented]
    def permit_params(_action, _subject)
      raise NotImplemented
    end
  end
end

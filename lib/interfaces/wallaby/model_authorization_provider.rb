module Wallaby
  # Model Authorizer to provide authorization functions
  class ModelAuthorizationProvider
    class << self
      # @!attribute [w] provider_name
      attr_writer :provider_name
      # @!attribute [r] provider_name
      # @return [String/Symbol] provider name
      def provider_name
        @provider_name || name.demodulize.gsub(/(Authorization)?Provider/, EMPTY_STRING).underscore
      end

      # Template method to heck and see if current provider is in used.
      # @param _context [ActionController::Base]
      # @raise [Wallaby::NotImplemented]
      def available?(_context)
        raise NotImplemented
      end
    end

    attr_reader :context

    # @param context [ActionController::Base]
    def initialize(context)
      @context = context
    end

    # Check user's permission on given resource and subject.
    # It should raise error if denied and be used in controller.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @raise [Wallaby::NotImplemented]
    def authorize(_action, _subject)
      raise NotImplemented
    end

    # Check and see if a user has access to a specific resource/collection on given action.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @raise [Wallaby::NotImplemented]
    def authorized?(_action, _subject)
      raise NotImplemented
    end

    # Check and see if a user has no access to a specific resource/collection on given action.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::NotImplemented]
    def unauthorized?(action, subject)
      !authorized?(action, subject)
    end

    # Filter the scope based on user's permission.
    #
    # It should be used for collection.
    # @param _action [Symbol, String]
    # @param _scope [Object]
    # @raise [Wallaby::NotImplemented]
    def accessible_for(_action, _scope)
      raise NotImplemented
    end

    # Make sure that user can assign certain values to a record.
    #
    # It should be used when creating/updating record.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @raise [Wallaby::NotImplemented]
    def attributes_for(_action, _subject)
      raise NotImplemented
    end

    # @note Please make sure to return nil when the authorization doesn't support this feature.
    # This is a method for Strong params to ensure user can only modify the fields that they have permission.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @raise [Wallaby::NotImplemented]
    def permit_params(_action, _subject)
      raise NotImplemented
    end
  end
end

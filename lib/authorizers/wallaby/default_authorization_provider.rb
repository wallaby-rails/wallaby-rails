module Wallaby
  # Default authorization provider
  class DefaultAuthorizationProvider < ModelAuthorizationProvider
    # Always available.
    # @param _context [ActionController::Base]
    # @return [true]
    def self.available?(_context)
      true
    end

    # This will pull out the args required for contruction from context
    # @param _context [ActionController::Base]
    # @return [Hash] args for initialize
    def self.args_from(_context)
      {}
    end

    # Do nothing
    # @param _action [Symbol, String]
    # @param subject [Object, Class]
    def authorize(_action, subject)
      subject
    end

    # Always return true
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @return [true]
    def authorized?(_action, _subject)
      true
    end

    # Do nothing
    # @param _action [Symbol, String]
    # @param scope [Object]
    def accessible_for(_action, scope)
      scope
    end

    # Return empty attributes
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @return [Hash] empty hash
    def attributes_for(_action, _subject)
      {}
    end

    # @note Please make sure to return nil when the authorization doesn't support this feature.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @return [nil]
    def permit_params(_action, _subject)
      # Do nothing
    end
  end
end

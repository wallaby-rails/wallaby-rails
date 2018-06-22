module Wallaby
  # Default authorization provider
  class DefaultAuthorizationProvider < ModelAuthorizationProvider
    # Always available.
    # @param _context [ActionController::Base]
    def self.available?(_context)
      true
    end

    # Do nothing
    # @param _context [ActionController::Base]
    def initialize(_context)
      # Do nothing
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
    # @return [Boolean]
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
    def attributes_for(_action, _subject)
      {}
    end

    # @note Please make sure to return nil when the authorization doesn't support this feature.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @return [nil, Array]
    def permit_params(_action, _subject)
      # Do nothing
    end
  end
end

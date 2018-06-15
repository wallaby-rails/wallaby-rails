module Wallaby
  # Default authorization provider
  class DefaultAuthorizationProvider < ModelAuthorizationProvider
    # Check and see if current provider is in used.
    # @param _context [ActionController::Base]
    def self.available?(_context)
      true
    end

    # Constructor
    # @param _context [ActionController::Base]
    def initialize(_context)
      # Do nothing
    end

    # Check user's permission on given resource and subject.
    # It should raise error if denied and be used in controller.
    # @param _action [Symbol, String]
    # @param subject [Object, Class]
    def authorize(_action, subject)
      subject
    end

    # Check and see if a user has access to a specific resource/collection on given action.
    # @param _action [Symbol, String]
    # @param _subject [Object, Class]
    # @return [Boolean]
    def authorized?(_action, _subject)
      true
    end

    # Filter the scope based on user's permission
    # It should be used for collection.
    # @param _action [Symbol, String]
    # @param _scope [Object]
    def accessible_for(_action, scope)
      scope
    end

    # Make sure that user can assign certain values to a record
    # It should be used when creating/updating record.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    def attributes_for(_action, subject)
      subject
    end

    # This is a method for Strong params to ensure user can only modify the fields that they have permission.
    # NOTE: Please make sure to return nil when the authorization doesn't support this feature.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @return [nil, Array]
    def permit_params(_action, _subject)
      # Do nothing
    end
  end
end

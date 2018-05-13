module Wallaby
  # Model Authorizer to provide authroization functions
  class ModelAuthorizationProvider
    # @param _context [ActionController::Base]
    def self.available?(_context)
      raise NotImplemented
    end

    # @param _context [ActionController::Base]
    def initialize(_context)
      raise NotImplemented
    end

    # Check and see if a user has access to a specific resource/collection.
    # Will raise error if denied.
    # @param _action [Symbol, String]
    # @param _target [Object, Class]
    def authorize(_action, _target)
      raise NotImplemented
    end

    # Check and see if a user has access to a specific resource/collection.
    # Returns true/false.
    # @param _action [Symbol, String]
    # @param _target [Object, Class]
    # @return [Boolean]
    def authorize?(_action, _target)
      raise NotImplemented
    end

    # Check and see if a user has access to a speicific field of resource
    # @param _action [Symbol, String]
    # @param _target [Object]
    # @param _field [String]
    # @return [Boolean]
    def authorize_field?(_action, _target, _field)
      raise NotImplemented
    end

    # Filter the scopes based on user's permission
    # @param _action [Symbol, String]
    # @param _scope [Object]
    def accessible_by(_action, _scope)
      raise NotImplemented
    end

    # Make sure that user can only assign
    # @param _action [Symbol, String]
    # @param _target [Object]
    def attributes_for(_action, _target)
      raise NotImplemented
    end

    # Strong params for a particular
    # @param _action [Symbol, String]
    # @param _target [Object]
    # @return [Array]
    def permit_params(_action, _target)
      raise NotImplemented
    end
  end
end

# frozen_string_literal: true

module Wallaby
  # Default authorization provider that allowlists everything.
  class DefaultAuthorizationProvider < ModelAuthorizationProvider
    # It returns false so that it can be used as the last resort.
    # @param _context [ActionController::Base, ActionView::Base]
    # @return [false]
    def self.available?(_context)
      false
    end

    # It returns empty hash.
    # @param context [ActionController::Base, ActionView::Base]
    # @return [Hash]
    def self.options_from(context)
      {
        user: context.try(:wallaby_user)
      }
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

    # @note Please make sure to return nil when the authorization provider doesn't support this feature.
    # @param _action [Symbol, String]
    # @param _subject [Object]
    # @return [nil]
    def permit_params(_action, _subject)
      # Do nothing
    end
  end
end

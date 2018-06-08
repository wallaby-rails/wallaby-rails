module Wallaby
  module Authorization
    # Default authorization strategy
    class DefaultStrategy
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
      # @return subject
      def authorize(_action, subject)
        subject
      end

      # Just return true
      # @param _action [Symbol, String]
      # @param _subject [Object, Class]
      # @return [Boolean] true
      def authorize?(_action, _subject)
        true
      end

      # Just return true
      # @param _action [Symbol, String]
      # @param _subject [Object]
      # @param _field [String]
      # @return [Boolean] true
      def authorize_field?(_action, _subject, _field)
        true
      end

      # Do nothing
      # @param _action [Symbol, String]
      # @param scope [Object]
      # @return scope
      def accessible_for(_action, scope)
        scope
      end

      # Do nothing
      # @param _action [Symbol, String]
      # @param subject [Object]
      # @return subject
      def attributes_for(_action, subject)
        subject
      end

      # Just return nil
      # @param _action [Symbol, String]
      # @param _subject [Object]
      # @return [nil]
      def permit_params(_action, _subject)
        # Do nothing
      end
    end
  end
end

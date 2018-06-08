module Wallaby
  module Authorization
    # Default strategy for authorization
    class PunditStrategy
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
      # @param _target [Object, Class]
      # @return nil
      def authorize(_action, _target)
        # Do nothing
      end

      # Just return true
      # @param _action [Symbol, String]
      # @param _target [Object, Class]
      # @return [Boolean] true
      def authorize?(_action, _target)
        true
      end

      # Just return true
      # @param _action [Symbol, String]
      # @param _target [Object]
      # @param _field [String]
      # @return [Boolean] true
      def authorize_field?(_action, _target, _field)
        true
      end

      # Do nothing
      # @param _action [Symbol, String]
      # @param scope [Object]
      # @return [Object]
      def accessible_by(_action, scope)
        scope
      end

      # Do nothing
      # @param _action [Symbol, String]
      # @param _target [Object]
      # @return nil
      def attributes_for(_action, _target)
        # Do nothing
      end

      # Just return nil
      # @param _action [Symbol, String]
      # @param _target [Object]
      # @return [nil]
      def permit_params(_action, _target)
        # Do nothing
      end
    end
  end
end

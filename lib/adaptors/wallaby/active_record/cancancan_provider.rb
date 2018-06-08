module Wallaby
  class ActiveRecord
    # Model Authorizer to provide authroization functions
    class CancancanProvider < ModelAuthorizationProvider
      # @param context [ActionController::Base]
      def self.available?(context)
        context.respond_to?(:current_ability)
      end

      # @param context [ActionController::Base]
      def initialize(context)
        @current_ability = context.current_ability
      end

      # Check and see if a user has access to a specific resource/collection.
      # Will raise error if denied.
      # @param action [Symbol, String]
      # @param target [Object, Class]
      def authorize(action, target)
        @current_ability.authorize! action, target
      end

      # Check and see if a user has access to a specific resource/collection.
      # Returns true/false.
      # @param action [Symbol, String]
      # @param target [Object, Class]
      # @return [Boolean]
      def authorize?(action, target)
        @current_ability.can? action, target
      end

      # Check and see if a user has access to a speicific field of resource
      # @param action [Symbol, String]
      # @param target [Object]
      # @param _field [String]
      # @return [Boolean]
      def authorize_field?(action, target, _field)
        @current_ability.can? action, target
      end

      # Filter the scopes based on user's permission
      # @param action [Symbol, String]
      # @param scope [Object]
      def accessible_by(action, scope)
        scope.accessible_by(@current_ability, action)
      end

      # Make sure that user can only assign the values allowed
      # @param action [Symbol, String]
      # @param target [Object]
      def attributes_for(action, target)
        @current_ability.attributes_for action, target
      end

      # Just return nil
      # @param _action [Symbol, String]
      # @param _target [Object]
      # @return [Array, nil]
      def authorized_fields(_action, _target)
        nil
      end
    end
  end
end

module Wallaby
  module Authorization
    # Cancancan authorization strategy
    class CancancanStrategy
      # @param context [ActionController::Base]
      def self.available?(context)
        context.respond_to?(:current_ability) && context.current_ability.present?
      end

      # Store current_ability for CanCanCan authorization
      # @param context [ActionController::Base]
      def initialize(context)
        @current_ability = context.current_ability
      end

      # Delegate authorize to current_ability
      # @param action [Symbol, String]
      # @param subject [Object, Class]
      # @return nil
      def authorize(action, subject)
        @current_ability.authorize! action, subject
      end

      # Delegate authorize? to current_ability
      # @param action [Symbol, String]
      # @param subject [Object, Class]
      # @return [Boolean] true
      def authorize?(action, subject)
        @current_ability.can? action, subject
      end

      # Delegate authorize_field? to current_ability
      # @param action [Symbol, String]
      # @param subject [Object]
      # @param _field [String]
      # @return [Boolean] true
      def authorize_field?(action, subject, _field)
        @current_ability.can? action, subject
      end

      # Delegate accessible_for to current_ability
      # @param action [Symbol, String]
      # @param scope [Object]
      # @return [Object]
      def accessible_for(action, scope)
        return scope unless scope.respond_to? :accessible_by
        scope.accessible_by @current_ability, action
      end

      # Delegate attributes_for to current_ability
      # @param action [Symbol, String]
      # @param subject [Object]
      # @return nil
      def attributes_for(action, subject)
        @current_ability.attributes_for action, subject
      end

      # Just return nil
      # @param action [Symbol, String]
      # @param subject [Object]
      # @return [nil]
      def permit_params(action, subject)
        # Do nothing
      end
    end
  end
end

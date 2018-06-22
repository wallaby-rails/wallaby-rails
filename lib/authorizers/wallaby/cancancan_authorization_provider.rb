module Wallaby
  # Base Cancancan authorization provider
  class CancancanAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if Cancancan is in used
    # @param context [ActionController::Base]
    def self.available?(context)
      defined?(CanCanCan) && context.respond_to?(:current_ability) && context.current_ability.present?
    end

    delegate :current_ability, :current_user, to: :@context

    # Store current context for later
    # @param context [ActionController::Base]
    def initialize(context)
      @context = context
    end

    # Check user's permission for an action on given subject.
    # This method will be used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return nil
    def authorize(action, subject)
      current_ability.authorize! action, subject
    rescue ::CanCan::AccessDenied
      Rails.logger.info I18n.t(
        'errors.unauthorized.cancancan',
        user: current_user,
        action: action,
        subject: subject
      )
      raise Unauthorized
    end

    # Check and see if user is allowed to perform an action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Boolean]
    def authorized?(action, subject)
      current_ability.can? action, subject
    end

    # Check and see
    # @param action [Symbol, String]
    # @param scope [Object]
    # @return [Object]
    def accessible_for(action, scope)
      return scope unless scope.respond_to? :accessible_by
      scope.accessible_by current_ability, action
    end

    # Delegate attributes_for to current_ability
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return nil
    def attributes_for(action, subject)
      current_ability.attributes_for action, subject
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

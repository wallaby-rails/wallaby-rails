module Wallaby
  # Base Pundit authorization provider
  class PunditAuthorizationProvider < ModelAuthorizationProvider
    # Check if current context is using pundit
    # @param context [ActionController::Base]
    def self.available?(context)
      context.respond_to?(:pundit_user) && context.respond_to?(:policy)
    end

    delegate :current_user, to: :@context

    # Store context for Pundit authorization
    # @param context [ActionController::Base]
    def initialize(context)
      @context = context
    end

    # Check user's permission for an action.
    # This method will be used in controller most likely.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return nil
    def authorize(action, subject)
      @context.authorize subject, normalize(action)
    rescue ::NotAuthorizedError
      Rails.logger.info I18n.t(
        'errors.unauthorized.cancancan',
        user: current_user,
        action: action,
        subject: subject
      )
      raise Unauthorized
    end

    # Check and see if user is allowed to perform an action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Boolean]
    def authorized?(action, subject)
      actioning = action + (action.end_with?('?') ? '' : '?')
      policy = @context.policy(subject)
      policy.respond_to(actioning) && policy.public_send(actioning)
    end

    # Delegate accessible_for to current_ability
    # @param _action [Symbol, String]
    # @param scope [Object]
    # @return [Object]
    def accessible_for(_action, scope)
      @context.policy_scope(scope) || scope
    end

    # Delegate attributes_for to current_ability
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return nil
    def attributes_for(action, subject)
      policy = @context.policy(subject)
      if policy.respond_to? "attributes_for_#{action}"
        policy.public_send "attributes_for_#{action}", subject, action
      elsif policy.respond_to? 'attributes_for'
        policy.public_send 'attributes_for', subject, action
      else
        {}
      end
    end

    # Just return nil
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [nil]
    def permit_params(action, subject)
      @context.permitted_attributes subject, action
    end
  end
end

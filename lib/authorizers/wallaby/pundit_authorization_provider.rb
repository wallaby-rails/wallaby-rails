module Wallaby
  # Base Pundit authorization provider
  class PunditAuthorizationProvider < ModelAuthorizationProvider
    # Check if current context is using pundit
    # @param context [ActionController::Base]
    def self.available?(context)
      defined?(Pundit) && context.respond_to?(:pundit_user) && context.respond_to?(:policy)
    end

    delegate :current_user, to: :@context

    # Store context for Pundit authorization
    # @param context [ActionController::Base]
    def initialize(context)
      @context = context
    end

    # Check user's permission for an action on given subject.
    # This method will be used in controller most likely.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return nil
    def authorize(action, subject)
      @context.authorize(subject, normalize(action)) && subject
    rescue ::Pundit::NotAuthorizedError
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
      action_query = normalize action
      policy = @context.policy subject
      policy.respond_to?(action_query) && policy.public_send(action_query)
    end

    # Delegate attributes_for to current_ability
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return nil
    def attributes_for(action, subject)
      policy = @context.policy(subject)
      method =
        if policy.respond_to? "attributes_for_#{action}"
          "attributes_for_#{action}"
        elsif policy.respond_to? 'attributes_for'
          'attributes_for'
        end
      value = method && policy.public_send(method)
      Rails.logger.warn I18n.t('error') if !method
      value || {}
    end

    # Just return nil
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [nil]
    def permit_params(action, subject)
      policy = @context.policy subject
      # @see https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L258
      method =
        if policy.respond_to? "permitted_attributes_for_#{action}"
          "permitted_attributes_for_#{action}"
        else
          'permitted_attributes'
        end
      policy.public_send(method).presence
    end

    private

    def normalize(action)
      action.to_s + (action.to_s.end_with?('?') ? '' : '?')
    end
  end
end

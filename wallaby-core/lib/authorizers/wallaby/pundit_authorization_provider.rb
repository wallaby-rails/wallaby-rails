# frozen_string_literal: true

module Wallaby
  # {https://github.com/varvet/pundit Pundit} base authorization provider.
  class PunditAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if Pundit is in use.
    # @param context [ActionController::Base, ActionView::Base]
    # @return [true] if Pundit is in use
    # @return [false] otherwise
    def self.available?(context)
      defined?(Pundit) && context.respond_to?(:pundit_user)
    end

    # Get the information from context for {ModelAuthorizationProvider#initialize}
    # @param context [ActionController::Base, ActionView::Base]
    # @return [Hash] options
    def self.options_from(context)
      {
        user: context.try(:pundit_user) || context.try(:wallaby_user)
      }
    end

    # Check user's permission for an action on given subject.
    #
    # This method is mostly used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Forbidden] when user is not authorized to perform the action.
    def authorize(action, subject)
      Pundit.authorize(user, subject, normalize(action)) && subject
    rescue ::Pundit::NotAuthorizedError
      Logger.error <<~MESSAGE
        #{Utils.inspect user} is forbidden to perform #{action} on #{Utils.inspect subject}
      MESSAGE
      raise Forbidden
    end

    # Check and see if user is allowed to perform an action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if user is allowed to perform the action
    # @return [false] otherwise
    def authorized?(action, subject)
      policy = Pundit.policy!(user, subject)
      policy.try normalize(action)
    end

    # Restrict user to access certain scope/query.
    # @param _action [Symbol, String]
    # @param scope [Object]
    # @return [Object]
    def accessible_for(_action, scope)
      Pundit.policy_scope!(user, scope)
    end

    # Restrict user to assign certain values.
    #
    # It will do a lookup in policy's methods and pick the first available method:
    #
    # - `attributes_for_#{action}`
    # - `attributes_for`
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [Hash] field value paired hash that user's allowed to assign
    def attributes_for(action, subject)
      policy = Pundit.policy!(user, subject)
      policy.try("attributes_for_#{action}") || policy.try('attributes_for') || {}
    end

    # Restrict user for mass assignment.
    #
    # It will do a lookup in policy's methods and pick the first available method:
    #
    # - `permitted_attributes_for_#{ action }`
    # - `permitted_attributes`
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [Array] field list that user's allowed to change.
    def permit_params(action, subject)
      policy = Pundit.policy!(user, subject)
      # @see https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L258
      policy.try("permitted_attributes_for_#{action}") || policy.try('permitted_attributes')
    end

    protected

    # Convert action to pundit method name
    # @param action [Symbol, String]
    # @return [String] e.g. `create?`
    def normalize(action)
      "#{action}?".tr('??', '?')
    end
  end
end

module Wallaby
  # Pundit base authorization provider
  class PunditAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if Pundit is in use.
    # @param context [ActionController::Base]
    # @return [true] if Pundit is in use.
    # @return [false] if Pundit is not in use.
    def self.available?(context)
      defined?(Pundit) && context.respond_to?(:pundit_user)
    end

    delegate :current_user, to: :context

    # Check user's permission for an action on given subject.
    #
    # This method will be used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::Unauthorized] when user is not authorized to perform the action.
    def authorize(action, subject)
      context.send(:authorize, subject, normalize(action)) && subject
    rescue ::Pundit::NotAuthorizedError
      Rails.logger.info I18n.t('errors.unauthorized', user: current_user, action: action,subject: subject)
      raise Unauthorized
    end

    # Check and see if user is allowed to perform an action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Boolean]
    def authorized?(action, subject)
      action_query = normalize action
      policy = context.send :policy, subject
      policy.respond_to?(action_query) && policy.public_send(action_query)
    end

    # Restrict user to assign certain values.
    #
    # It will do a lookup in policy's methods and pick the first available method:
    #
    # - attributes\_for\_#\{ action \}
    # - attributes\_for
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [Hash] field value paired hash that user's allowed to assign
    def attributes_for(action, subject)
      policy = context.send :policy, subject
      value = Utils.try_to(policy, "attributes_for_#{action}") || Utils.try_to(policy, "attributes_for")
      Rails.logger.warn I18n.t('error.pundit.not_found.attributes_for', subject: subject) unless method
      value || {}
    end

    # Restrict user for mass assignment.
    #
    # It will do a lookup in policy's methods and pick the first available method:
    #
    # - permitted\_attributes\_for\_#\{ action \}
    # - permitted\_attributes
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [Array] field list that user's allowed to change.
    def permit_params(action, subject)
      policy = context.send :policy, subject
      # @see https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L258
      Utils.try_to(policy, "permitted_attributes_for_#{action}") || Utils.try_to(policy, "permitted_attributes")
    end

    private

    # Convert action to pundit method name
    # @param action [Symbol, String]
    # @return [String] e.g. `create?`
    def normalize(action)
      "#{action}?".tr('??', '?')
    end
  end
end

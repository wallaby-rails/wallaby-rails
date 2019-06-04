module Wallaby
  # Cancancan base authorization provider
  class CancancanAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if Cancancan is in use.
    # @param context [ActionController::Base]
    # @return [true] if Cancancan is in use.
    # @return [false] if Cancancan is not in use.
    def self.available?(context)
      defined?(CanCanCan) && defined?(Ability) && context.respond_to?(:current_ability)
    end

    # This will pull out the args required for contruction from context
    # @param context [ActionController::Base]
    # @return [Hash] args for initialize
    def self.args_from(context)
      { ability: context.current_ability, user: ModuleUtils.try_to(context, :current_user) }
    end

    # @!attribute [r] ability
    # @return [Ability]
    attr_reader :ability

    def initialize(ability:, user: nil)
      @ability = ability
      @user = user
    end

    # Check user's permission for an action on given subject.
    # This method will be used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::Forbidden] when user is not authorized to perform the action.
    def authorize(action, subject)
      ability.authorize! action, subject
    rescue ::CanCan::AccessDenied
      Rails.logger.info I18n.t('errors.unauthorized', user: user, action: action, subject: subject)
      raise Forbidden
    end

    # Check and see if user is allowed to perform an action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Boolean]
    def authorized?(action, subject)
      ability.can? action, subject
    end

    # Restrict user to access certain scope.
    # @param action [Symbol, String]
    # @param scope [Object]
    # @return [Object]
    def accessible_for(action, scope)
      ModuleUtils.try_to(scope, :accessible_by, ability, action) || scope
    end

    # Restrict user to assign certain values.
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return nil
    def attributes_for(action, subject)
      ability.attributes_for action, subject
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

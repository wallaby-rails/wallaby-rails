# frozen_string_literal: true

module Wallaby
  # @note This authorization provider DOES NOT use the existing
  #   {https://www.rubydoc.info/github/CanCanCommunity/cancancan/CanCan%2FControllerAdditions:current_ability
  #   current_ability} helper. It has its own version of {#ability} instance.
  # {https://github.com/CanCanCommunity/cancancan CanCanCan} base authorization provider.
  class CancancanAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if CanCanCan is in use.
    # @param context [ActionController::Base, ActionView::Base]
    # @return [true] if CanCanCan is in use
    # @return [false] otherwise.
    def self.available?(context)
      defined?(CanCanCan) && context.respond_to?(:current_ability)
    end

    # Get the information from context for {ModelAuthorizationProvider#initialize}
    # @param context [ActionController::Base, ActionView::Base]
    # @return [Hash] options
    def self.options_from(context)
      {
        ability: context.try(:current_ability),
        user: context.try(:wallaby_user)
      }
    end

    # @!attribute [w] ability
    attr_writer :ability

    # @!attribute [r] ability
    # @return [Ability] the Ability instance for {#user #user} or from the {#options}[:ability]
    def ability
      # NOTE: use current_ability's class to create the ability instance.
      # just in case that developer uses a different Ability class (e.g. UserAbility)
      @ability ||= options[:ability] || Ability.new(user)
    end

    # Check user's permission for an action on given subject.
    #
    # This method will be mostly used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Forbidden] when user is not authorized to perform the action.
    def authorize(action, subject)
      ability.authorize! action, subject
    rescue ::CanCan::AccessDenied
      Logger.error <<~MESSAGE
        #{Utils.inspect user} is forbidden to perform #{action} on #{Utils.inspect subject}
      MESSAGE
      raise Forbidden
    end

    # Check and see if user is allowed to perform an action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if user is allowed to perform the action
    # @return [false] otherwise
    def authorized?(action, subject)
      ability.can? action, subject
    end

    # Restrict user to access certain scope/query.
    # @param action [Symbol, String]
    # @param scope [Object]
    # @return [Object]
    def accessible_for(action, scope)
      scope.try(:accessible_by, ability, action) || scope
    end

    # @!method attributes_for(action, subject)
    # Restrict user to assign certain values.
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return nil
    delegate :attributes_for, to: :ability

    # Simply return nil as CanCanCan doesn't provide such a feature.
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [nil]
    def permit_params(action, subject)
      # Do nothing
    end
  end
end

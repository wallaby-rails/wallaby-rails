module Wallaby
  # Model Authorizer to provide authorization functions
  # @since 5.2.0
  class ModelAuthorizer < AbstractModelAuthorizer
    # @!method initializeinitialize(context, model_class)
    # @param context [ActionController::Base]
    # @param model_class [Class]

    # @!method authorize(action, subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check user's permission for given action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::Forbidden] when user is not authorized to perform the action.
    # @since 5.2.0

    # @!method authorized?(action, subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has permission for given action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if user is authorized to perform the action
    # @return [false] if user is not authorized to perform the action
    # @since 5.2.0

    # @!method unauthorized?(action, subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has no permission for given action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if user is not authorized to perform the action
    # @return [false] if user is authorized to perform the action
    # @since 5.2.0

    # @!method accessible_for(action, scope)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's access to certain scope.
    # @param action [Symbol, String]
    # @param scope [Object]
    # @return [Object] filtered scope
    # @since 5.2.0

    # @!method attributes_for(action, subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's modification to certain fields of given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Hash] allowed attributes
    # @since 5.2.0

    # @!method permit_params(action, subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's mass assignment to certain fields of given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Array] field list for mass assignment
    # @since 5.2.0
  end
end

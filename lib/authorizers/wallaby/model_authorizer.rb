module Wallaby
  # Model Authorizer to provide authorization functions
  # @since 5.2.0
  class ModelAuthorizer < AbstractModelAuthorizer
    # @!method authorize(_action, _subject)
    # @param (see ModelAuthorizationProvider#authorize)
    # @return (see ModelAuthorizationProvider#authorize)
    # @raise [Wallaby::Forbidden] when user is not authorized to perform the action.
    # @see ModelAuthorizationProvider#authorize
    # @since 5.2.0

    # @!method authorized?(_action, _subject)
    # @param (see ModelAuthorizationProvider#authorized?)
    # @return [true] if user is authorized to perform the action
    # @return [false] if user is not authorized to perform the action
    # @see ModelAuthorizationProvider#authorized?
    # @since 5.2.0

    # @!method unauthorized?(action, subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to check if user has no permission for given action on given subject.
    # @param (see ModelAuthorizationProvider#unauthorized?)
    # @return [true] if user is not authorized to perform the action
    # @return [false] if user is authorized to perform the action
    # @see ModelAuthorizationProvider#unauthorized?
    # @since 5.2.0

    # @!method accessible_for(_action, _scope)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's access to certain scope.
    # @param (see ModelAuthorizationProvider#accessible_for)
    # @return [Object] filtered scope
    # @see ModelAuthorizationProvider#accessible_for
    # @since 5.2.0

    # @!method attributes_for(_action, _subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's modification to certain fields of given subject.
    # @param (see ModelAuthorizationProvider#attributes_for)
    # @return [Hash] allowed attributes
    # @see ModelAuthorizationProvider#attributes_for
    # @since 5.2.0

    # @!method permit_params(_action, _subject)
    # @note It can be overridden in subclasses for customization purpose.
    # This is the template method to restrict user's mass assignment to certain fields of given subject.
    # @param (see ModelAuthorizationProvider#permit_params)
    # @return [Array] field list for mass assignment
    # @see ModelAuthorizationProvider#permit_params
    # @since 5.2.0
  end
end

# frozen_string_literal: true

module Wallaby
  # Authorizer related
  module Authorizable
    # Model authorizer for current modal class.
    # @return [ModelAuthorizer] model authorizer
    # @see #authorizer_of
    # @since wallaby-5.2.0
    def current_authorizer
      @current_authorizer ||=
        authorizer_of(current_model_class).tap do |authorizer|
          Logger.debug %(Current authorizer: #{authorizer.try(:class)}), sourcing: false
        end
    end

    # Check if user is allowed to perform action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if allowed
    # @return [false] if not allowed
    # @since wallaby-5.2.0
    def authorized?(action, subject)
      return false unless subject

      klass = subject.is_a?(Class) ? subject : subject.class
      authorizer_of(klass).authorized?(action, subject)
    end

    # Check if user is allowed to perform action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if not allowed
    # @return [false] if allowed
    # @since wallaby-5.2.0
    def unauthorized?(action, subject)
      !authorized?(action, subject)
    end

    protected

    # @param model_class [Class]
    # @return [ModelAuthorizer] model authorizer for given model
    # @see AuthorizerFinder#execute
    # @since wallaby-5.2.0
    def authorizer_of(model_class)
      AuthorizerFinder.new(
        script_name: script_name,
        model_class: model_class,
        current_controller_class: wallaby_controller
      ).execute.create model_class, self
    end
  end
end

# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class AuthorizerFinder < DecoratorFinder
    # Find authorizer class by script name and model class from the following places:
    #
    # - {#controller_class #controller_class}'s {Configurable::ClassMethods#model_authorizer #model_authorizer}
    # - possible authorizer class built from script name and model class,
    #   e.g. **/admin** and **Order::Item** will give us the possible authorizers:
    #   - Admin::Order::ItemAuthorizer
    #   - Order::ItemAuthorizer
    #   - ItemAuthorizer
    # - {#controller_class #controller_class}'s default
    #   {Configurable::ClassMethods#application_authorizer #application_authorizer}
    # @return [Class] authorizer class
    def execute
      controller_class.model_authorizer ||
        possible_default_class ||
        controller_class.application_authorizer
    end
  end
end

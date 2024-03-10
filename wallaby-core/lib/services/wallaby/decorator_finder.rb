# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class DecoratorFinder < ClassFinder
    # Find decorator class by script name and model class from the following places:
    #
    # - {#controller_class}'s {Configurable::ClassMethods#resource_decorator #resource_decorator}
    # - possible decorator class built from script name and model class,
    #   e.g. **/admin** and **Order::Item** will give us the possible decorators:
    #   - Admin::Order::ItemDecorator
    #   - Order::ItemDecorator
    #   - ItemDecorator
    # - {#controller_class}'s default
    #   {Configurable::ClassMethods#application_decorator #application_decorator}
    # @return [Class] decorator class
    def execute
      controller_class.resource_decorator ||
        possible_default_class ||
        controller_class.application_decorator
    end

    protected

    # (see ControllerFinder#execute)
    def controller_class
      @controller_class ||= ControllerFinder.new(
        script_name: script_name,
        model_class: model_class,
        current_controller_class: current_controller_class
      ).execute
    end
  end
end

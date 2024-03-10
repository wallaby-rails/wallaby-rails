# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class ServicerFinder < ControllerFinder
    # Find servicer class by script name and model class from the following places:
    #
    # - {#current_controller_class #current_controller_class}'s
    #   {Configurable::ClassMethods#model_servicer #model_servicer}
    # - possible servicer class built from script name and model class,
    #   e.g. **/admin** and **Order::Item** will give us the possible servicers:
    #   - Admin::Order::ItemServicer
    #   - Order::ItemServicer
    #   - ItemServicer
    # - {#current_controller_class #current_controller_class}'s default
    #   {Configurable::ClassMethods#application_servicer #application_servicer}
    # @return [Class] servicer class
    def execute
      current_controller_class.model_servicer ||
        possible_default_class ||
        current_controller_class.application_servicer
    end

    protected

    # (see ClassFinder#denamespace?)
    def denamespace?
      true
    end
  end
end

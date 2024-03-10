# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class ControllerFinder < ClassFinder
    # Find controller class by script name and model class from the following places:
    #
    # - {ClassFinder#current_controller_class #current_controller_class}
    #   if {ClassFinder#current_controller_class #current_controller_class}'s model is the same as given
    #   {ClassFinder#model_class #model_class}
    # - possible controller class built from script name and model class,
    #   e.g. **/admin** and **Order::Item** will give us the possible controller `Admin::Order::ItemsController`
    # - {ClassFinder#current_controller_class #current_controller_class}'s default
    #   {Configurable::ClassMethods#application_controller #application_controller}
    # @return [Class] controller class
    def execute
      return current_controller_class if model_class == current_controller_class.try(:model_class)

      possible_default_class || current_controller_class.try(:application_controller)
    end

    protected

    # (see ClassFinder#denamespace?)
    def denamespace?
      false
    end
  end
end

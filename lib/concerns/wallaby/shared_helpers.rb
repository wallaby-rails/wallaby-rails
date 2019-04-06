module Wallaby
  # Shared helpers
  module SharedHelpers
    protected

    # Fetch value for given attribute.
    #
    # If it's used in controller, it will fetch it from class attribute.
    # If it's used in view, it will fetch it from controller.
    # @param attribute_name [String, Symbol] instance attribute name
    # @param class_attribute_name [String, Symbol] class attribute name
    # @return [Object] the value
    def controller_to_get(attribute_name, class_attribute_name = nil)
      class_attribute_name ||= attribute_name
      return ModuleUtils.try_to self.class, class_attribute_name if is_a? ::ActionController::Base # controller?
      ModuleUtils.try_to controller, attribute_name # view?
    end
  end
end

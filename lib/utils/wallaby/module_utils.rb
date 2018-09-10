module Wallaby
  # Utils for module and class
  module ModuleUtils
    # Check if a child class inherits from parent class
    # @param child [Class] child class
    # @param parent [Class] parent class
    def self.inheritance_check(child, parent)
      return unless child && parent
      return if child < parent
      raise ::ArgumentError, I18n.t('errors.invalid.inheritance', klass: child, parent: parent)
    end
  end
end

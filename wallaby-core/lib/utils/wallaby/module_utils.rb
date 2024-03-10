# frozen_string_literal: true

module Wallaby
  # Utils for module and class
  module ModuleUtils
    class << self
      # @deprecated
      def try_to(_subject, _method_id, *_args)
        Deprecator.alert method(__callee__), from: '0.3.0'
      end

      # Check whether a class is anonymous or not
      # @param klass [Class]
      # @return [true] if a class is anonymous
      # @return [false] otherwise
      def anonymous_class?(klass)
        klass.name.blank? || klass.to_s.start_with?('#<Class')
      end

      # Check if a child class inherits from parent class
      # @param child [Class] child class
      # @param parent [Class] parent class
      # @raise [ArgumentError] if given class is not a child of the other class
      def inheritance_check(child, parent)
        return unless child && parent
        return if child < parent

        raise ::ArgumentError, Locale.t('errors.invalid.inheritance', klass: child, parent: parent)
      end

      # If block is given, run the block. Otherwise, return subject
      # @param subject [Object]
      # @yield [subject]
      def yield_for(subject)
        block_given? ? yield(subject) : subject
      end
    end
  end
end

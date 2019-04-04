module Wallaby
  # Utils for module and class
  module ModuleUtils
    class << self
      # A helper method to check if subject responds to given method and to return the result if so
      # @param subject [Object]
      # @param method_id [String, Symbol]
      # @param args [Array] a list of arguments
      # @return [Object] result from executing given method on subject
      # @return [nil] if subject doesn't respond to given method
      def try_to(subject, method_id, *args, &block)
        return if method_id.blank?
        subject.respond_to?(method_id) && subject.public_send(method_id, *args, &block) || nil
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
        raise ::ArgumentError, I18n.t('errors.invalid.inheritance', klass: child, parent: parent)
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

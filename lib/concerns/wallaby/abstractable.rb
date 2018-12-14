module Wallaby
  # Abstract related class methods
  module Abstractable
    # Configurable attributes and class methods for abstract
    module ClassMethods
      # @return [true] if class is abstract
      # @return [false] if class is not abstract
      def abstract
        @abstract ||= false
      end

      # Mark class abstract
      # @return [true]
      def abstract!
        @abstract = true
      end
    end
  end
end

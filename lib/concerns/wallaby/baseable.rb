module Wallaby
  # Abstract related class methods
  module Baseable
    # Configurable attributes and class methods for marking a class base and skipping {Wallaby::Map mapping}
    module ClassMethods
      # @return [true] if class is a base class
      # @return [false] if class is not a base class
      def base_class?
        @base_class ||= false
      end

      # Mark class a base class
      # @return [true]
      def base_class!
        @base_class = true
      end
    end
  end
end

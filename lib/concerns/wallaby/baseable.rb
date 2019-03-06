module Wallaby
  # Abstract related class methods
  module Baseable
    # Configurable attributes and class methods for marking a class base and skipping {Wallaby::Map mapping}
    module ClassMethods
      # @deprecated Use {#base_class!} instead. It will be removed from 5.3.*
      def abstract!
        Utils.deprecate 'deprecation.abstract!', caller: caller
        super if defined? super
        base_class!
      end

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

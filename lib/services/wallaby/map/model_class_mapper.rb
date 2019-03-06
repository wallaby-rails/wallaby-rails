module Wallaby
  class Map
    # Generate a map.
    class ModelClassMapper
      # Iterate all classes and generate a hash using their model classes as the key
      # @see #map
      # @param class_array [Array<Class>]
      # @return [Hash] model class => descendant class
      def self.map(class_array, &block)
        new.send :map, class_array, &block
      end

      protected

      # @return [Hash] model class => descendant class
      def map(class_array)
        (class_array || EMPTY_ARRAY).each_with_object({}) do |klass, map|
          next if anonymous?(klass) || base_class?(klass) || !klass.model_class
          map[klass.model_class] = block_given? ? yield(klass) : klass
        end
      end

      # @see Wallaby::ModuleUtils.anonymous_class?
      def anonymous?(klass)
        ModuleUtils.anonymous_class? klass
      end

      # @param klass [Class]
      # @return [Boolean] whether the class is base or not
      def base_class?(klass)
        ModuleUtils.try_to klass, :base_class?
      end
    end
  end
end

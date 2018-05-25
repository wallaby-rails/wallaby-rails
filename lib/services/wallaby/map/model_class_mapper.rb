module Wallaby
  class Map
    # @private
    # Generate a map.
    class ModelClassMapper
      # Iterate all classes and generate a hash using their model classes as the key
      # @see #map
      # @param class_array [Array<Class>]
      # @return [Hash] model class => decendant class
      def self.map(class_array)
        new.send :map, class_array
      end

      protected

      # @return [Hash] model class => decendant class
      def map(class_array)
        (class_array || EMPTY_ARRAY).each_with_object({}) do |klass, map|
          next if anonymous?(klass) || abstract?(klass)
          begin
            map[klass.model_class] = block_given? ? yield(klass) : klass
          rescue Wallaby::ModelNotFound
            Rails.logger.error Utils.translate_class(self, :missing_model_class, model: klass.name)
          end
        end
      end

      # @param klass [Class]
      # @return [Boolean] whether the class is anonymous
      def anonymous?(klass)
        Utils.anonymous_class? klass
      end

      # @param klass [Class]
      # @return [Boolean] whether the class is abstract, only applicable to controller class
      def abstract?(klass)
        klass.respond_to?(:abstract?) && klass.abstract?
      end
    end
  end
end

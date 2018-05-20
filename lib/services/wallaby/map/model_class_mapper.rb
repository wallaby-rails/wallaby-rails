module Wallaby
  class Map
    # @private
    # Generate a map.
    class ModelClassMapper
      # @param base_class [Class]
      def initialize(base_class)
        @base_class = base_class
      end

      # Iterate all decendant classes and generate a hash using their model classes as the key
      # @return [Hash] model class => decendant class
      def map
        classes_array.each_with_object({}) do |klass, map|
          next if anonymous?(klass) || abstract?(klass)
          begin
            map[klass.model_class] = block_given? ? yield(klass) : klass
          rescue Wallaby::ModelNotFound
            Rails.logger.error Utils.translate_class(
              self, :missing_model_class, model: klass.name
            )
          end
        end
      end

      protected

      # @param klass [Class]
      # @return [Boolean] whether the class is anonymous
      def anonymous?(klass)
        Utils.anonymous_class? klass
      end

      # @param klass [Class]
      # @return [Boolean] whether the class is abstract, only applicable to
      #   controller class
      def abstract?(klass)
        klass.respond_to?(:abstract?) && klass.abstract?
      end

      # @return [Array<Class>] all descendants
      def classes_array
        @base_class.try(:descendants) || EMPTY_ARRAY
      end
    end
  end
end

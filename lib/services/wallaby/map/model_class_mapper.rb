module Wallaby
  class Map
    # @private
    # To find out all descendant classes and convert them if necessary.
    class ModelClassMapper
      def initialize(base_class)
        @base_class = base_class
      end

      # @return [Array] a list of non-anonymous descendant classes
      def map
        classes_array.each_with_object({}) do |klass, map|
          next if anonymous? klass
          map[klass.model_class] = block_given? ? yield(klass) : klass
        end
      end

      protected

      # @return [Boolean]
      def anonymous?(klass)
        klass.name.blank?
      end

      # @return [Array] all descendants
      def classes_array
        @base_class.try(:descendants) || EMPTY_ARRAY
      end
    end
  end
end

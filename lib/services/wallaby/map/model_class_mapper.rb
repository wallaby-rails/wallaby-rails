module Wallaby
  class Map
    # To map model class to a klass
    class ModelClassMapper
      DEFAULT_BLOCK = ->(same) { same }.freeze

      def initialize(base_class)
        @base_class = base_class
      end

      def map(&block)
        block ||= DEFAULT_BLOCK
        classes_array.each_with_object({}) do |klass, map|
          next if anonymous? klass
          map[klass.model_class] = block.call klass
        end
      end

      protected

      def anonymous?(klass)
        klass.name.blank?
      end

      def classes_array
        @base_class.try(:descendants) || EMPTY_ARRAY
      end
    end
  end
end

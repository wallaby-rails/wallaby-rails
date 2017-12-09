module Wallaby
  class Map
    # To map model class to a klass
    class ModelClassMapper
      def initialize(base_class)
        @base_class = base_class
      end

      def map
        (@base_class.try(:subclasses) || EMPTY_HASH)
          .each_with_object({}) do |klass, map|
          next if anonymous? klass
          map[klass.model_class] = block_given? ? yield(klass) : klass
        end
      end

      protected

      def anonymous?(klass)
        klass.name.blank?
      end
    end
  end
end

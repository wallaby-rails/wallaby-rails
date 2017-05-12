module Wallaby
  class Map
    # To map model class to a klass
    class ModelClassMapper
      def initialize(base_class)
        @base_class = base_class
      end

      def map
        return {} if @base_class.blank?
        @base_class.subclasses.each_with_object({}) do |klass, map|
          unless anonymous? klass
            map[klass.model_class] = block_given? ? yield(klass) : klass
          end
        end
      end

      protected

      def anonymous?(klass)
        klass.name.blank?
      end
    end
  end
end

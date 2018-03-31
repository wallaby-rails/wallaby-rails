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
          begin
            map[klass.model_class] = block_given? ? yield(klass) : klass
          rescue Wallaby::ModelNotFound
            Rails.logger.warn \
              Utils.t(self, :missing_model_class, class_name: klass)
          end
        end
      end

      protected

      # @param klass [Class]
      # @return [Boolean] whether the class is anonymous
      def anonymous?(klass)
        Utils.anonymous_class? klass
      end

      # @return [Array<Class>] all descendants
      def classes_array
        @base_class.try(:descendants) || EMPTY_ARRAY
      end
    end
  end
end

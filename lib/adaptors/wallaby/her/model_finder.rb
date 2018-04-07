module Wallaby
  class Her
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      # @return [Array<Class>] a list of Her classes
      def all
        ObjectSpace
          .each_object(Class)
          .each_with_object([]) do |klass, result|
            result << klass if klass < ::Her::Model
          end
      end
    end
  end
end

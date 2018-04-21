module Wallaby
  class Her
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      # Find out all the classes that include Her::Model
      # @return [Array<Class>] a list of Her classes
      def all
        ObjectSpace
          .each_object(Class)
          .each_with_object([]) do |klass, result|
            next if Utils.anonymous_class?(klass)
            result << klass if klass < ::Her::Model
          end
      end
    end
  end
end

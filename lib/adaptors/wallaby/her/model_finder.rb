module Wallaby
  class Her
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      # Find out all the classes that include Her::Model
      # @return [Array<Class>] a list of Her classes
      def all
        ObjectSpace
          .each_object(Class)
          .select do |klass|
            klass < ::Her::Model && !ModuleUtils.anonymous_class?(klass)
          end
      end
    end
  end
end

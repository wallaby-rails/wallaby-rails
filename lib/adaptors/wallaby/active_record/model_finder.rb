module Wallaby
  class ActiveRecord
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      # @return [Array<Class>] a list of ActiveRecord subclasses
      def all
        self.class.base.descendants.reject do |model_class|
          abstract?(model_class) || anonymous?(model_class) || habtm?(model_class)
        end.sort_by(&:to_s)
      end

      # This is only for ActiveRecord
      # @return [ApplicationRecord, ActiveRecord::Base] base ActiveRecord class
      def self.base
        return ::ApplicationRecord if defined? ::ApplicationRecord
        ::ActiveRecord::Base
      end

      private

      # Is model class abstract?
      # @param model_class [Class]
      # @return [Boolean]
      def abstract?(model_class)
        model_class.abstract_class?
      end

      # @see Wallaby::ModuleUtils.anonymous_class?
      def anonymous?(model_class)
        ModuleUtils.anonymous_class? model_class
      end

      # Check and see if given model class is intermediate class that generated
      # for has and belongs to many assocation
      # @param model_class [Class]
      # @return [Boolean]
      def habtm?(model_class)
        model_class.name.index('HABTM')
      end
    end
  end
end

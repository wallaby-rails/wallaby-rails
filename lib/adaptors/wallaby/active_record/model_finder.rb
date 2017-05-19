module Wallaby
  class ActiveRecord
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      def all
        self.class.base.descendants.reject do |model_class|
          abstract?(model_class) || anonymous?(model_class) \
            || schema?(model_class) || habtm?(model_class)
        end.sort_by(&:to_s)
      end

      def self.base
        return ::ApplicationRecord if defined? ::ApplicationRecord
        ::ActiveRecord::Base
      end

      private

      def abstract?(model_class)
        model_class.abstract_class?
      end

      def anonymous?(model_class)
        model_class.to_s.start_with? '#<Class'
      end

      def schema?(model_class)
        model_class.name == 'ActiveRecord::SchemaMigration'
      end

      def habtm?(model_class)
        model_class.name.index('HABTM')
      end
    end
  end
end

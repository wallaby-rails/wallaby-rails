module Wallaby
  class ActiveRecord
    # @private
    # Model finder
    class ModelFinder < ::Wallaby::ModelFinder
      # @return [Array] a list of ActiveRecord subclasses
      def all
        self.class.base.descendants.reject do |model_class|
          abstract?(model_class) || anonymous?(model_class) \
            || schema?(model_class) || habtm?(model_class)
        end.sort_by(&:to_s)
      end

      # This is only for ActiveRecord
      # @return [ApplicationRecord, ActiveRecord::Base]
      def self.base
        return ::ApplicationRecord if defined? ::ApplicationRecord
        ::ActiveRecord::Base
      end

      private

      # Is model class abstract?
      # @param [Class] model class
      # @return [Boolean]
      def abstract?(model_class)
        model_class.abstract_class?
      end

      # Is model class anonymous?
      # @param [Class] model class
      # @return [Boolean]
      def anonymous?(model_class)
        model_class.to_s.start_with? '#<Class'
      end

      # Is model class the shcema migration class?
      # @param [Class] model class
      # @return [Boolean]
      def schema?(model_class)
        model_class.name == 'ActiveRecord::SchemaMigration'
      end

      # Check and see if given model class is intermediate class that generated
      # for has and belongs to many assocation
      # @param [Class] model class
      # @return [Boolean]
      def habtm?(model_class)
        model_class.name.index('HABTM')
      end
    end
  end
end

# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    # Finder to return all the appropriate ActiveRecord models.
    class ModelFinder < ::Wallaby::ModelFinder
      # Return a list of ActiveRecord::Base subclasses that aren't one of the following types:
      #
      # 1. abstract class
      # 2. anonymous class
      # 3. the HABTM relation class
      # @return [Array<Class>]
      def all
        ::ActiveRecord::Base.descendants.reject do |model_class|
          application_record?(model_class) ||
            model_class.abstract_class? ||
            anonymous?(model_class) ||
            model_class.name.index('HABTM') ||
            invalid_class_name?(model_class)
        end.sort_by(&:to_s)
      end

      protected

      def application_record?(model_class)
        defined?(::ApplicationRecord) && model_class == ::ApplicationRecord
      end

      # @param model_class [Class]
      # @see Wallaby::ModuleUtils.anonymous_class?
      def anonymous?(model_class)
        ModuleUtils.anonymous_class?(model_class).tap do |result|
          Logger.warn "Anonymous class is detected for table #{model_class.try :table_name}" if result
        end
      end

      # To exclude classes that have invalid class name, e.g. **primary::SchemaMigration** from Rails test
      # @param model_class [Class]
      def invalid_class_name?(model_class)
        model_class.name.constantize
        false
      rescue NameError
        true
      end
    end
  end
end

module Wallaby
  class ActiveRecord
    class ModelDecorator
      class FieldsBuilder
        # @private
        # To build the metadata for sti column
        class StiBuilder
          # @param model_class [Class] model class
          def initialize(model_class)
            @model_class = model_class
          end

          # update the metadata
          # @param metadata [Hash]
          # @param column [ActiveRecord::ConnectionAdapters::Column]
          def update(metadata, column)
            return unless @model_class.inheritance_column == column.name
            metadata[:type] = 'sti'.freeze
            metadata[:sti_class_list] = sti_list(find_parent_of(@model_class))
          end

          private

          # @param klass [Class]
          # @return [Array<Class>] a list of STI classes for this model
          def sti_list(klass)
            list = klass.descendants << klass
            list.sort_by(&:name)
          end

          # @param klass [Class]
          # @return [Class] the top parent class in the STI hierarchy
          def find_parent_of(klass)
            parent = klass
            parent = parent.superclass until top_parent?(parent.superclass)
            parent
          end

          # @param klass [Class]
          # @return [Boolean] whether the class is ActiveRecord base class
          def top_parent?(klass)
            klass == ModelFinder.base || Utils.try_to(klass, :abstract_class?)
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelDecorator
      class FieldsBuilder
        # This class updates the field metadata's value of **type** and **sti_class_list**
        # for STI (Single Table Inheritance) model
        class StiBuilder
          # @param model_class [Class]
          def initialize(model_class)
            @model_class = model_class
          end

          # Update the field metadata's value for **type** and **sti_class_list**
          # @param metadata [Hash]
          # @param column [ActiveRecord::ConnectionAdapters::Column]
          def update(metadata, column)
            return unless @model_class.inheritance_column == column.name

            metadata[:type] = 'sti'
            metadata[:sti_class_list] = sti_list(find_sti_parent_of(@model_class))
          end

          protected

          # Return the alphabet-order STI list
          # by traversing the inheritance tree for given model.
          # @param klass [Class]
          # @return [Array<Class>]
          def sti_list(klass)
            (klass.descendants << klass).sort_by(&:name).uniq
          end

          # Find out which parent is the one that can give us the STI list.
          # @param klass [Class]
          # @return [Class]
          def find_sti_parent_of(klass)
            parent = klass
            parent = parent.superclass until not_sti_parent?(parent.superclass)
            parent
          end

          # @param klass [Class]
          # @return [true] if klass is ActiveRecord::Base or abstract
          # @return [false] otherwise
          def not_sti_parent?(klass)
            klass == ::ActiveRecord::Base || klass.try(:abstract_class?)
          end
        end
      end
    end
  end
end

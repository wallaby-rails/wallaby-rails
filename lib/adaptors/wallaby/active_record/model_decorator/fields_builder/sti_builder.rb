module Wallaby
  class ActiveRecord
    class ModelDecorator
      class FieldsBuilder
        # To build the metadata for sti column
        class StiBuilder
          def initialize(model_class)
            @model_class = model_class
          end

          def update(metadata, column)
            return unless @model_class.inheritance_column == column.name
            metadata[:type] = 'sti'.freeze
            metadata[:sti_class_list] = sti_list(find_parent_of(@model_class))
          end

          private

          def sti_list(klass)
            list = klass
                    .descendants
                    .each_with_object([klass]) do |child, result|
                      result << child
                    end
            list.sort_by(&:name)
          end

          def find_parent_of(model_class)
            parent = model_class
            parent = parent.superclass until top_parent?(parent.superclass)
            parent
          end

          def top_parent?(klass)
            klass == ModelFinder.base ||
              klass.respond_to?(:abstract_class?) && klass.abstract_class?
          end
        end
      end
    end
  end
end

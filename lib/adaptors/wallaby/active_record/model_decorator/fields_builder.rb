module Wallaby
  class ActiveRecord
    class ModelDecorator
      # To search and build the metadata for fields
      class FieldsBuilder
        def initialize(model_class)
          @model_class = model_class
        end

        def general_fields
          @model_class.columns.each_with_object({}) do |column, fields|
            metadata = {
              name: column.name,
              type: column.type.to_s.freeze,
              label: @model_class.human_attribute_name(column.name),
              is_origin: true
            }
            sti_builder.update(metadata, column)
            fields[column.name] = metadata
          end
        end

        def association_fields
          @model_class.reflections.each_with_object({}) do |(name, ref), fields|
            metadata = {
              name: name, type: ref.macro.to_s,
              label: @model_class.human_attribute_name(name),
              is_origin: true
            }
            association_builder.update(metadata, ref)
            polymorphic_builder.update(metadata, ref)
            fields[name] = metadata
          end
        end

        protected

        def sti_builder
          @sti_builder ||= StiBuilder.new(@model_class)
        end

        def association_builder
          @association_builder ||= AssociationBuilder.new
        end

        def polymorphic_builder
          @polymorphic_builder ||= PolymorphicBuilder.new
        end
      end
    end
  end
end

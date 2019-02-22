module Wallaby
  class ActiveRecord
    class ModelDecorator
      # To search and build the metadata for fields
      class FieldsBuilder
        # @param model_class [Class] model class
        def initialize(model_class)
          @model_class = model_class
        end

        # @return [Hash<String, Hash>] a hash for general fields
        def general_fields
          @model_class.columns.each_with_object({}) do |column, fields|
            metadata = {
              type: column.type.to_s.freeze,
              label: @model_class.human_attribute_name(column.name)
            }
            sti_builder.update(metadata, column)
            fields[column.name] = metadata
          end
        end

        # @return [Hash<String, Hash>] a hash for general fields
        def association_fields
          @model_class.reflections.each_with_object({}) do |(name, ref), fields|
            metadata = {
              type: ref.macro.to_s,
              label: @model_class.human_attribute_name(name)
            }
            association_builder.update(metadata, ref)
            polymorphic_builder.update(metadata, ref)
            fields[name] = metadata
          end
        end

        protected

        # @see Wallaby::ActiveRecord::ModelDecorator::StiBuilder
        def sti_builder
          @sti_builder ||= StiBuilder.new(@model_class)
        end

        # @see Wallaby::ActiveRecord::ModelDecorator::AssociationBuilder
        def association_builder
          @association_builder ||= AssociationBuilder.new
        end

        # @see Wallaby::ActiveRecord::ModelDecorator::PolymorphicBuilder
        def polymorphic_builder
          @polymorphic_builder ||= PolymorphicBuilder.new
        end
      end
    end
  end
end

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
            fields[column.name] = {
              name:       column.name,
              type:       column.type.to_s,
              label:      @model_class.human_attribute_name(column.name),
              is_origin:  true
            }
          end
        end

        def association_fields
          @model_class
            .reflections
            .each_with_object({}) do |(field_name, reflection), fields|
            fields[field_name] = {}
            required_association_metadata_for(fields[field_name], reflection)
            association_metadata_for(fields[field_name], reflection)
            polymorphic_metadata_for(fields[field_name], reflection)
          end
        end

        protected

        def through?(reflection)
          reflection.is_a? ::ActiveRecord::Reflection::ThroughReflection
        end

        def type_for(reflection)
          reflection.macro
        end

        def foreign_key_for(reflection, type)
          if :belongs_to == type || reflection.polymorphic?
            reflection.foreign_key
          elsif reflection.collection?
            # @see https://github.com/rails/rails/blob/92703a9ea5d8b96f30e0b706b801c9185ef14f0e/activerecord/lib/active_record/associations/builder/collection_association.rb#L50
            reflection.name.to_s.singularize << '_ids'
          else
            reflection.association_foreign_key
          end
        end

        def polymorphic_list_for(reflection)
          available_model_class.each_with_object([]) do |model_class, list|
            if model_defined_polymorphic_name? model_class, reflection.name
              list << model_class
            end
          end
        end

        def model_defined_polymorphic_name?(model_class, polymorphic_name)
          polymorphic_name_sym = polymorphic_name.try(:to_sym)
          model_class.reflections.any? do |_field_name, reflection|
            reflection.options[:as].try(:to_sym) == polymorphic_name_sym
          end
        end

        def available_model_class
          Map.mode_map.select do |_, mode|
            mode == ::Wallaby::ActiveRecord
          end.keys
        end

        def required_association_metadata_for(metadata, reflection)
          type = type_for reflection
          field_name = reflection.name.to_s
          metadata[:name] = field_name
          metadata[:type] = type.to_s
          metadata[:label] = field_name.titleize
          metadata[:is_origin] = true
        end

        def association_metadata_for(metadata, reflection)
          type = type_for reflection
          metadata[:is_association] = true
          metadata[:is_through] = through?(reflection)
          metadata[:has_scope] = reflection.scope.present?
          metadata[:foreign_key] = foreign_key_for(reflection, type)
        end

        def polymorphic_metadata_for(metadata, reflection)
          if reflection.polymorphic?
            metadata[:is_polymorphic] = reflection.polymorphic?
            metadata[:polymorphic_type] = reflection.foreign_type
            metadata[:polymorphic_list] = polymorphic_list_for(reflection)
          else
            metadata[:class] = reflection.klass
          end
        end
      end
    end
  end
end

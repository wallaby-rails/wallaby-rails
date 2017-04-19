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

        def scope?(reflection)
          reflection.scope.present?
        end

        def through?(reflection)
          reflection.respond_to? :delegate_reflection
        end

        def polymorphic?(reflection)
          reflection.options[:polymorphic].present?
        end

        def extract_type_from(reflection)
          target =
            if through?(reflection)
              reflection.delegate_reflection
            else
              reflection
            end
          target.class.name.match(/([^:]+)Reflection/)[1].underscore
        end

        def foreign_key_for(reflection, type)
          return reflection.foreign_key if 'belongs_to' == type
          reflection.association_foreign_key.try do |foreign_key|
            /many/ =~ type ? "#{foreign_key}s" : foreign_key
          end
        end

        def polymorphic_type_for(reflection, type)
          return unless polymorphic? reflection
          foreign_key = foreign_key_for reflection, type
          foreign_key.gsub(/_ids?$/, '_type')
        end

        def polymorphic_list_for(reflection)
          return [] unless polymorphic? reflection
          available_model_class.each_with_object([]) do |model_class, list|
            if model_defined_polymorphic_name? model_class, reflection.name
              list << model_class
            end
            list
          end
        end

        def model_defined_polymorphic_name?(model_class, polymorphic_name)
          model_class.reflections.any? do |_field_name, reflection|
            reflection.options[:as].to_s == polymorphic_name.to_s
          end
        end

        def available_model_class
          Wallaby::Map.mode_map.select do |_, mode|
            mode == Wallaby::ActiveRecord
          end.keys
        end

        def class_for(reflection)
          reflection.class_name.constantize unless polymorphic? reflection
        end

        def required_association_metadata_for(metadata, reflection)
          type = extract_type_from reflection
          field_name = reflection.name.to_s
          metadata[:name] = field_name
          metadata[:type] = type
          metadata[:label] = field_name.titleize
          metadata[:is_origin] = true
          metadata[:class] = class_for(reflection)
        end

        def association_metadata_for(metadata, reflection)
          type = extract_type_from reflection
          metadata[:is_association] = true
          metadata[:is_through] = through?(reflection)
          metadata[:has_scope] = scope?(reflection)
          metadata[:foreign_key] = foreign_key_for(reflection, type)
        end

        def polymorphic_metadata_for(metadata, reflection)
          type = extract_type_from reflection
          metadata[:is_polymorphic] = polymorphic?(reflection)
          metadata[:polymorphic_type] = polymorphic_type_for(reflection, type)
          metadata[:polymorphic_list] = polymorphic_list_for(reflection)
        end
      end
    end
  end
end

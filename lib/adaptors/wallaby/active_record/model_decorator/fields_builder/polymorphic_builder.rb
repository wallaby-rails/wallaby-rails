module Wallaby
  class ActiveRecord
    class ModelDecorator
      class FieldsBuilder
        # @!visibility private
        # To build the metadata for polymorphic
        class PolymorphicBuilder
          # update the metadata
          # @param metadata [Hash]
          # @param reflection [ActiveRecord::Reflection]
          def update(metadata, reflection)
            if reflection.polymorphic?
              metadata[:is_polymorphic] = true
              metadata[:polymorphic_type] = reflection.foreign_type
              metadata[:polymorphic_list] = polymorphic_list_for(reflection)
            else
              metadata[:class] = reflection.klass
            end
          end

          private

          # @param reflection [ActiveRecord::Reflection]
          # @return [Array<Class>] a list of classes for this polymorphism
          def polymorphic_list_for(reflection)
            all_model_class.each_with_object([]) do |model_class, list|
              list << model_class if polymorphic_defined? model_class, reflection.name
            end
          end

          # @return [Array<Class>] a list of all ActiveRecord classes
          def all_model_class
            Map
              .mode_map
              .select { |_, mode| mode == ::Wallaby::ActiveRecord }.keys
          end

          # @param model_class [Class] model class
          # @param polymorphic_name [String] polymorphic name
          # @return [Boolean] if polymorphism defined?
          def polymorphic_defined?(model_class, polymorphic_name)
            polymorphic_name_sym = polymorphic_name.try(:to_sym)
            model_class.reflections.any? do |_field_name, reflection|
              reflection.options[:as].try(:to_sym) == polymorphic_name_sym
            end
          end
        end
      end
    end
  end
end

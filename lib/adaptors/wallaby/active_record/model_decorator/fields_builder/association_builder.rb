module Wallaby
  class ActiveRecord
    class ModelDecorator
      class FieldsBuilder
        # @private
        # To build the metadata for associations
        class AssociationBuilder
          # Update the metadata
          # @param metadata [Hash]
          # @param reflection [ActiveRecord::Reflection]
          def update(metadata, reflection)
            type = reflection.macro
            metadata[:is_association] = true
            metadata[:is_through] = through?(reflection)
            metadata[:has_scope] = scope?(reflection)
            metadata[:foreign_key] = foreign_key_for(reflection, type)
          end

          private

          # @param reflection [ActiveRecord::Reflection]
          # @param type [Symbol]
          # @return [String] foreign key
          def foreign_key_for(reflection, type)
            if type == :belongs_to || reflection.polymorphic?
              reflection.foreign_key
            elsif reflection.collection?
              # @see https://github.com/rails/rails/blob/92703a9ea5d8b96f30e0b706b801c9185ef14f0e/activerecord/lib/active_record/associations/builder/collection_association.rb#L50
              reflection.name.to_s.singularize << '_ids'
            else
              reflection.association_foreign_key
            end
          end

          # @param reflection [ActiveRecord::Reflection]
          # @return [Boolean] whether it's a through relation
          def through?(reflection)
            reflection.is_a? ::ActiveRecord::Reflection::ThroughReflection
          end

          # @param reflection [ActiveRecord::Reflection]
          # @return [Boolean] whether it has scope
          def scope?(reflection)
            reflection.scope.present?
          end
        end
      end
    end
  end
end

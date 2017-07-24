module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Filter the params
      class Permitter
        def initialize(model_decorator)
          @model_decorator = model_decorator
        end

        def simple_field_names
          field_names =
            non_range_fields.keys +
            belongs_to_fields.map do |_, metadata|
              [metadata[:foreign_key], metadata[:polymorphic_type]]
            end.flatten.compact
          fields = [@model_decorator.primary_key, 'created_at', 'updated_at']
          field_names.reject { |field_name| fields.include? field_name }
        end

        def compound_hashed_fields
          field_names =
            range_fields.keys +
            many_association_fields.map { |_, metadata| metadata[:foreign_key] }
          field_names.each_with_object({}) { |name, hash| hash[name] = [] }
        end

        protected

        def non_association_fields
          @model_decorator
            .fields.reject { |_, metadata| metadata[:is_association] }
        end

        def non_range_fields
          non_association_fields
            .reject { |_, metadata| /range|point/ =~ metadata[:type] }
        end

        def range_fields
          non_association_fields.select do |_, metadata|
            /range|point/ =~ metadata[:type]
          end
        end

        def association_fields
          @model_decorator.fields.select do |_, metadata|
            metadata[:is_association] &&
              !metadata[:has_scope] && !metadata[:is_through]
          end
        end

        def many_association_fields
          association_fields.select { |_, metadata| /many/ =~ metadata[:type] }
        end

        def belongs_to_fields
          association_fields.select do |_field_name, metadata|
            'belongs_to' == metadata[:type]
          end
        end
      end
    end
  end
end

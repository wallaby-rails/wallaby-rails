# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Allowlist the params for mass-assignment
      class Permitter
        # @param model_decorator [Wallaby::ModelDecorator]
        def initialize(model_decorator)
          @model_decorator = model_decorator
        end

        # @return [Array<String>] a list of field names of general types
        def simple_field_names
          field_names =
            non_range_fields.keys +
            belongs_to_fields.flat_map do |_, metadata|
              [metadata[:foreign_key], metadata[:polymorphic_type]]
            end.compact
          fields = [@model_decorator.primary_key, 'created_at', 'updated_at']
          field_names.reject { |field_name| fields.include?(field_name) }.uniq
        end

        # @return [Array<String>] a list of field names of range and association
        def compound_hashed_fields
          field_names =
            range_fields.keys +
            many_association_fields.map { |_, metadata| metadata[:foreign_key] }
          field_names.each_with_object({}) { |name, hash| hash[name] = [] }
        end

        protected

        # @return [Array<String>] a list of field names that ain't association
        def non_association_fields
          @model_decorator.fields.reject { |_, metadata| metadata[:is_association] }
        end

        # @return [Array<String>] a list of field names that ain't range
        def non_range_fields
          non_association_fields.reject { |_, metadata| /range|point/ =~ metadata[:type] }
        end

        # @return [Array<String>] a list of range field names
        def range_fields
          non_association_fields.select { |_, metadata| /range|point/ =~ metadata[:type] }
        end

        # @return [Array<String>] a list of association field names
        def association_fields
          @model_decorator.fields.select { |_, metadata| metadata[:is_association] && !metadata[:has_scope] }
        end

        # @return [Array<String>] a list of many association field names:
        #   - has_many
        #   - has_and_belongs_to_many
        def many_association_fields
          association_fields.select { |_, metadata| metadata[:type].include?('many') }
        end

        # @return [Array<String>] a list of belongs_to association field names
        def belongs_to_fields
          association_fields.select { |_, metadata| metadata[:type] == 'belongs_to' }
        end
      end
    end
  end
end

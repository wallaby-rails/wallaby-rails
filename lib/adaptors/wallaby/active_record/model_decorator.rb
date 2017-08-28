module Wallaby
  class ActiveRecord
    # Modal decorator
    class ModelDecorator < ::Wallaby::ModelDecorator
      def fields
        # origin metadata coming from data source
        # should be frozen
        @fields ||= ::HashWithIndifferentAccess.new.tap do |hash|
          if model_class.table_exists?
            hash.merge! general_fields
            hash.merge! association_fields
            hash.except!(*foreign_keys_from_associations)
          end
        end.freeze
      end

      def index_fields
        @index_fields ||= Utils.clone fields
      end

      def show_fields
        @show_fields  ||= Utils.clone fields
      end

      def form_fields
        @form_fields  ||= Utils.clone fields
      end

      def index_field_names
        @index_field_names ||= begin
          types = %w(binary citext hstore json jsonb text tsvector xml)
          index_fields.reject do |_field_name, metadata|
            metadata[:is_association] || types.include?(metadata[:type])
          end.keys
        end
      end

      def form_field_names
        @form_field_names ||= begin
          fields = %W(#{primary_key} updated_at created_at)
          form_fields.reject do |field_name, metadata|
            fields.include?(field_name) ||
              metadata[:has_scope] || metadata[:is_through]
          end.keys
        end
      end

      def form_active_errors(resource)
        resource.errors
      end

      def primary_key
        @model_class.primary_key
      end

      def guess_title(resource)
        resource.public_send title_field_finder.find
      end

      protected

      def field_builder
        @field_builder ||= FieldsBuilder.new @model_class
      end

      def title_field_finder
        @title_field_finder ||=
          TitleFieldFinder.new @model_class, general_fields
      end

      delegate :general_fields, :association_fields, to: :field_builder

      def foreign_keys_from_associations(associations = association_fields)
        associations.each_with_object([]) do |(_field_name, metadata), keys|
          keys << metadata[:foreign_key] if metadata[:foreign_key]
          keys << metadata[:polymorphic_type] if metadata[:polymorphic_type]
          keys
        end
      end

      def many_associations(associations = association_fields)
        associations.select do |_field_name, metadata|
          /many/ =~ metadata[:type] && !metadata[:is_through]
        end
      end

      def belongs_to_associations(associations = association_fields)
        associations.select do |_field_name, metadata|
          metadata[:type] == 'belongs_to'
        end
      end
    end
  end
end

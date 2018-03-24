module Wallaby
  class ModelDecorator
    # Field helper for model decorator
    module FieldHelpers
      # @return [Hash] metadata information for a given field
      def metadata_of(field_name)
        fields[field_name] || {}
      end

      # @return [String] label for a given field
      def label_of(field_name)
        metadata_of(field_name)[:label]
      end

      # @return [String, Symbol] type for a given field
      def type_of(field_name)
        validate_presence_of field_name, metadata_of(field_name)[:type]
      end

      # @return [Hash] index metadata information for a given field
      def index_metadata_of(field_name)
        index_fields[field_name] || {}
      end

      # @return [String] index label for a given field
      def index_label_of(field_name)
        index_metadata_of(field_name)[:label]
      end

      # @return [String, Symbol] index type for a given field
      def index_type_of(field_name)
        validate_presence_of field_name, index_metadata_of(field_name)[:type]
      end

      # @return [Hash] show metadata information for a given field
      def show_metadata_of(field_name)
        show_fields[field_name] || {}
      end

      # @return [String] show label for a given field
      def show_label_of(field_name)
        show_metadata_of(field_name)[:label]
      end

      # @return [String, Symbol] show type for a given field
      def show_type_of(field_name)
        validate_presence_of field_name, show_metadata_of(field_name)[:type]
      end

      # @return [Hash] form metadata information for a given field
      def form_metadata_of(field_name)
        form_fields[field_name] || {}
      end

      # @return [String] form label for a given field
      def form_label_of(field_name)
        form_metadata_of(field_name)[:label]
      end

      # @return [String, Symbol] form type for a given field
      def form_type_of(field_name)
        validate_presence_of field_name, form_metadata_of(field_name)[:type]
      end
    end
  end
end

module Wallaby
  module Services
    class RecordDecorator
      attr_reader :record

      def self.build record
        new record
      end

      def initialize record
        @record = record
        delegate_attributes
      end

      def delegate_attributes
        record.attribute_names.each do |field|
          method_name = field
          define_singleton_method method_name do
            record.send field
          end unless methods.include? method_name

          ['list', 'show', 'edit'].each do |act|
            method_name = "#{ act }_#{ field }"
            define_singleton_method method_name do
              send act, field
            end unless methods.include? method_name
          end
        end
      end

      def value_of field
        record.send field
      end

      def type_of field
        record.column_for_attribute field
      end

      def list field
        build_value_for field
      end

      def show field
        build_value_for field
      end

      def edit field
        build_value_for field
      end

      def build_value_for field, type = nil
        type ||= type_of(field).type
        send type, record.send(field)
      end

      def string value
        value
      end

      def integer value
        value
      end

      def text value
        value
      end

      def datetime value
        I18n.localize value
      end

      def to_label
        # guessing the name from columns
        candidate_fields = record.class.columns.select do |field|
          field.type == :string
        end

        field = candidate_fields.find do |field|
          field.name =~ %r/(title|name)/i
        end or candidate_fields.first

        send field.name
      end
    end
  end
end
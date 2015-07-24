module Wallaby
  module Services
    class ModelDecorator
      attr_reader :model_class

      def self.build model_class
        decorator = subclasses.find do |klass|
          klass.name == "#{ model_class.name }Decorator"
        end || self
        decorator.new model_class
      end

      def self.model_class
        name.gsub('Decorator', '').constantize
      end

      def initialize model_class = nil
        @model_class = model_class || self.class.model_class
      end

      def columns
        model_class.columns
      end

      def fields
        model_class.column_names
      end

      def list_fields
        fields
      end

      def show_fields
        fields
      end

      def field_labels
        fields.map do |field|
          label_of field
        end
      end

      def model_name
        model_class.model_name
      end

      def editable_fields
        fields
      end

      def label_of field
        model_class.human_attribute_name field
      end

      def type_of field
        model_class.column_types[field].type.to_s
      end
    end
  end
end
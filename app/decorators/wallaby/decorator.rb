module Wallaby
  class Decorator
    include ModelMethods
    include RecordMethods

    class << self
      attr_writer :model_class

      def build model, record = nil
        decorator = subclasses.find do |klass|
          klass.name == "#{ model.name }Decorator" ||
          klass.model_class.name == model.name
        end || self
        decorator.new model, record
      end

      def model_class
        @model_class ||= name.gsub('Decorator', '').constantize
      end
    end

    attr_reader :model_class, :record

    def initialize model_class = nil, record = nil
      @model_class = model_class || self.class.model_class
      @record = record
      delegate_attributes if record.present?
    end

    def delegate_attributes
      record.attribute_names.each do |field|
        method_name = field
        define_singleton_method method_name do
          record.send field
        end unless methods.include? method_name
      end
    end

    def to_label
      to_s
    end
  end
end
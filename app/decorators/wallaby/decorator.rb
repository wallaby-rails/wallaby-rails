module Wallaby
  class Decorator
    include ModelMethods
    include RecordMethods
    include ClassMethods

    attr_reader :model_class, :record

    def initialize record, model_class = nil
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
      candidates = record.class.columns.select do |column|
        column.type == :string
      end.map(&:name)
      title_or_name = candidates.grep(%r((\A|_)(name|title)\Z)).first
      if title_or_name.present?
        record.send title_or_name
      elsif candidates.first.present?
        record.send candidates.first
      else
        record.to_s
      end
    end
  end
end
module Wallaby
  class ActiveRecordModelDecorator
    def initialize model_class
      @model_class = model_class
    end

    def resources_name
      Wallaby::Utils.to_resources_name @model_class.name
    end

    def to_param
      resources_name
    end

    def to_s
      @model_class.model_name.human
    end

    def list_field_names
      @model_class.column_names
    end

    def label_of field_name
      @model_class.human_attribute_name field_name
    end
  end
end
module Wallaby::Decorator::RecordMethods
  def label_of field
    model_class.human_attribute_name field
  end

  def type_of field
    model_class.column_types[field].type.to_s
  end

  def list field
    send field
  end

  def show field
    send field
  end

  def new field
    send field
  end

  def edit field
    send field
  end
end
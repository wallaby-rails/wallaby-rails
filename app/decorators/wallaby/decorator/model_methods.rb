module Wallaby::Decorator::ModelMethods
  def model_name
    model_class.model_name
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

  def new_fields
    fields
  end

  def edit_fields
    fields
  end
end
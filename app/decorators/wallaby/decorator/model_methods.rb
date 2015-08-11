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
    model_class.columns.select do |column|
      ![ model_class.primary_key, 'updated_at', 'created_at' ].include? column.name
    end.map &:name
  end

  def edit_fields
    new_fields
  end
end
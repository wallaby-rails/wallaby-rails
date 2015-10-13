class Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder
  def initialize model_class
    @model_class = model_class
  end

  def build
    fields      = general_fields.merge association_fields
    excludings  = foreign_keys_from_associations
    fields.except *excludings
  end

  protected
  def general_fields
    @model_class.columns.inject({}) do |fields, column|
      fields[column.name] = {
        type:   column.type,
        label:  @model_class.human_attribute_name(column.name)
      }
      fields
    end
  end

  def association_fields
    @model_class.reflect_on_all_associations.inject({}) do |fields, association|
      type  = extract_type_from association

      label = Wallaby::Utils.to_model_label association.class_name
      label = label.pluralize if /many|through/ =~ type

      fields[association.name] = { label: label, type: type }
      fields
    end
  end

  def foreign_keys_from_associations
    @model_class.reflect_on_all_associations.map &:foreign_key
  end

  def extract_type_from association
    type = association.class.name.match(/([^:]+)Reflection/)[1].underscore
    if /through/ =~ type
      extract_type_from association.delegate_reflection
    else
      type
    end
  end
end
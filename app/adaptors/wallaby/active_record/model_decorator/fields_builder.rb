class Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder
  def initialize model_class
    @model_class = model_class
  end

  def build
    fields      = general_fields.merge association_fields
    excludings  = foreign_keys_from_associations
    fields.except *excludings
  end

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
      type = extract_type_from association
      through = type == 'through'
      type = extract_type_from association.delegate_reflection if through

      label = Wallaby::Utils.to_model_label association.class_name
      label = label.pluralize if /many/ =~ type

      id_key = association.foreign_key
      id_key = "#{ association.name.to_s.singularize }_ids" if /many/ =~ type

      fields[association.name] = {
        label:      label,
        type:       type,
        id_key:     id_key,
        class_name: association.class_name,
        through:    through
      }
      fields
    end
  end

  def foreign_keys_from_associations
    @model_class.reflect_on_all_associations.map &:foreign_key
  end

  def extract_type_from association
    type = association.class.name.match(/([^:]+)Reflection/)[1].underscore
  end
end
class Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder
  def initialize(model_class)
    @model_class = model_class
  end

  def general_fields
    @general_fields ||= @model_class.columns.inject({}) do |fields, column|
      fields[column.name] = {
        name:   column.name,
        type:   column.type.to_s,
        label:  @model_class.human_attribute_name(column.name)
      }
      fields
    end
  end

  def association_fields
    @association_fields ||= @model_class.reflections.inject({}) do |fields, (field_name, reflection)|
      type = extract_type_from reflection

      fields[field_name] = {
        name:             field_name,
        type:             type,
        label:            field_name.titleize,
        is_association:   true,
        is_polymorphic:   is_polymorphic?(reflection),
        is_through:       is_through?(reflection),
        has_scope:        has_scope?(reflection),
        foreign_key:      foreign_key_for(reflection, type),
        polymorphic_type: polymorphic_type_for(reflection, type),
        polymorphic_list: polymorphic_list_for(reflection),
        class:            class_for(reflection)
      }
      fields
    end
  end

  protected
  def has_scope?(reflection)
    reflection.scope.present?
  end

  def is_through?(reflection)
    reflection.respond_to? :delegate_reflection
  end

  def is_polymorphic?(reflection)
    reflection.options[:polymorphic].present?
  end

  def extract_type_from(reflection)
    target = if is_through?(reflection)
      reflection.delegate_reflection
    else
      reflection
    end
    target.class.name.match(/([^:]+)Reflection/)[1].underscore
  end

  def foreign_key_for(reflection, type)
    foreign_key = reflection.association_foreign_key
    foreign_key = "#{ foreign_key }s" if /many/ =~ type
    foreign_key
  end

  def polymorphic_type_for(reflection, type)
    if is_polymorphic? reflection
      foreign_key = foreign_key_for reflection, type
      foreign_key.gsub %r(_ids?$), '_type'
    end
  end

  def polymorphic_list_for(reflection)
    if is_polymorphic? reflection
      available_model_class.inject([]) do |list, model_class|
        if model_defined_polymorphic_name? model_class, reflection.name
          list << model_class
        end
        list
      end
    end || []
  end

  def model_defined_polymorphic_name?(model_class, polymorphic_name)
    model_class.reflections.any? do |field_name, reflection|
      reflection.options[:as].to_s == polymorphic_name.to_s
    end
  end

  def available_model_class
    Wallaby.adaptor.model_finder.new.available
  end

  def class_for(reflection)
    reflection.class_name.constantize if !is_polymorphic? reflection
  end
end

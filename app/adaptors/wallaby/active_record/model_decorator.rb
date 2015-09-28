class Wallaby::ActiveRecord::ModelDecorator < Wallaby::ModelDecorator
  def primary_key
    @primary_key ||= model_class.primary_key
  end

  def collection
    model_class.where(nil)
  end

  def find_or_initialize id
    if id.present?
      model_class.find id
    else
      model_class.new
    end
  end

  def model_label
    model_class.name.gsub '::', ' '
  end

  def guess_label resource
    possible_attributes = resource.class.columns.select do |column|
      column.type == :string
    end
    possible_attribute = possible_attributes.find do |column|
      column.name =~ /title|name|string/
    end || possible_attributes.first
    [ resource.class, possible_attribute ? resource.send(possible_attribute.name) : nil ].compact.join ': '
  end

  def field_names
    @field_names ||= begin
      fields = @model_class.columns.map &:name
      if primary_key
        fields.delete primary_key
        fields.unshift primary_key
      end
      fields
    end || []
  end

  def field_labels
    @field_labels ||= @model_class.columns.inject({}) do |labels, column|
      labels[column.name] = @model_class.human_attribute_name column.name
      labels
    end || {}
  end

  def field_types
    @field_types ||= @model_class.columns.inject({}) do |types, column|
      types[column.name] = column.type
      types
    end || {}
  end

  def label_of field_name
    field_labels[field_name]
  end

  def type_of field_name
    field_types[field_name]
  end

  def index_field_names
    @index_field_names ||= field_names.dup
  end

  def index_field_labels
    @index_field_labels ||= field_labels.dup
  end

  def index_field_types
    @index_field_types ||= field_types.dup
  end

  def index_label_of field_name
    index_field_labels[field_name]
  end

  def index_type_of field_name
    index_field_types[field_name]
  end

  def show_field_names
    @show_field_names ||= field_names.dup
  end

  def show_field_labels
    @show_field_labels ||= field_labels.dup
  end

  def show_field_types
    @show_field_types ||= field_types.dup
  end

  def show_label_of field_name
    show_field_labels[field_name]
  end

  def show_type_of field_name
    show_field_types[field_name]
  end

  def form_field_names
    @form_field_names ||= field_names.reject do |field_name|
      [ primary_key, 'updated_at', 'created_at' ].include? field_name
    end
  end

  def form_field_labels
    @form_field_labels ||= field_labels.dup
  end

  def form_field_types
    @form_field_types ||= field_types.dup
  end

  def form_label_of field_name
    form_field_labels[field_name]
  end

  def form_type_of field_name
    form_field_types[field_name]
  end
end

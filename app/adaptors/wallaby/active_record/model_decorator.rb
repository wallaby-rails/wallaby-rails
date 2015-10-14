class Wallaby::ActiveRecord::ModelDecorator < Wallaby::ModelDecorator
  def primary_key
    @model_class.primary_key
  end

  def collection
    all_associations = @model_class.reflect_on_all_associations.map(&:name)
    query = @model_class.includes(*all_associations).where(nil)
  end

  def find_or_initialize id
    id.present? ? @model_class.find(id) : @model_class.new
  end

  def guess_title resource
    resource.send possible_title_column.name if possible_title_column.present?
  end

  def fields
    @fields ||= begin
      field_builder.general_fields
        .merge(field_builder.association_fields)
        .except(*field_builder.foreign_keys_from_associations)
    end
  end

  def index_fields
    @index_fields ||= fields.dup
  end

  def show_fields
    @show_fields ||= fields.dup
  end

  def form_fields
    @form_fields ||= fields.dup
  end

  def form_field_names
    @form_field_names ||= form_fields.reject do |key, value|
      %W( #{ primary_key } updated_at created_at ).include?(key) ||
      %w( has_one ).include?(form_type_of key) ||
      form_metadata_of(key)[:through]
    end.keys
  end

  def form_strong_param_names
    @form_strong_param_names ||= begin
      general_fields = field_builder.general_fields.keys
      many_fields = form_fields.select do |key, value|
        /many/ =~ value[:type]
      end.values.inject({}) do |hash, field|
        hash[field[:id_key]] = []
        hash
      end
      general_fields + [ many_fields ]
    end
  end

  protected
  def field_builder
    @field_builder ||= FieldsBuilder.new(@model_class)
  end

  def possible_title_columns
    @model_class.columns.select do |column|
      %i( string ).include? column.type
    end
  end

  def possible_title_column
    possible_title_columns.find do |column|
      %r(title|name|string) =~ column.name
    end or possible_title_columns.first
  end
end

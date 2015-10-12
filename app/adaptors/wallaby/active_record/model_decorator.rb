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
    @fields ||= FieldsBuilder.new(@model_class).build
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
    @form_field_names ||= form_fields.keys.reject do |field_name|
       %W( #{ primary_key } updated_at created_at ).include? field_name
    end
  end

  protected
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

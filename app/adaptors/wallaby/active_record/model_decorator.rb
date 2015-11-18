class Wallaby::ActiveRecord::ModelDecorator < Wallaby::ModelDecorator
  def collection(query = {}, options = {})
    search = @model_class.where(nil)
    # TODO: complete the query
    if options[:includes]
      associations  = field_builder.association_fields.keys
      search        = search.includes *(associations & index_field_names)
    end
    search
  end

  def find_or_initialize(id = nil)
    record = if id.present?
      @model_class.where(primary_key => id).first
    else
      @model_class.new
    end
  end

  def fields
    @fields ||= general_fields.merge(association_fields).except *foreign_keys_from_associations
  end

  def index_fields
    @index_fields ||= fields.reject do |field, metadata|
      metadata[:has_scope]
    end
  end

  def show_fields
    @show_fields  ||= fields.dup
  end

  def form_fields
    @form_fields  ||= fields.reject do |field, metadata|
      metadata[:has_scope]
    end
  end

  def form_field_names
    @form_field_names ||= form_fields.reject do |field_name, value|
      type        = form_type_of field_name
      is_through  = form_metadata_of(field_name)[:is_through]

      %W( #{ primary_key } updated_at created_at ).include?(field_name) ||
        type == 'has_one' || is_through
    end.keys
  end

  def form_strong_param_names
    @form_strong_param_names ||= general_form_field_names + [ many_association_form_params ]
  end

  def primary_key
    @model_class.primary_key
  end

  def guess_title(resource)
    resource.send possible_title_field_name if possible_title_field_name.present?
  end

  protected
  def field_builder
    @field_builder ||= FieldsBuilder.new @model_class
  end

  delegate :general_fields, :association_fields, to: :field_builder

  def possible_title_fields
    general_fields.values.select do |field|
      %i( string ).include? field[:type]
    end
  end

  def possible_title_field_name
    field = possible_title_fields.find do |field|
      %r(title|name|string) =~ field[:name]
    end || possible_title_fields.first
    field.try :[], :name
  end

  def foreign_keys_from_associations(associations = association_fields)
    associations.inject([]) do |keys, (field_name, metadata)|
      keys << metadata[:foreign_type]
      keys << metadata[:foreign_key]
    end.compact
  end

  def many_associations
    association_fields.select do |field_name, metadata|
      /many/ =~ metadata[:type] && !metadata[:is_through]
    end
  end

  def belongs_to_associations
    association_fields.select do |field_name, metadata|
      'belongs_to' == metadata[:type]
    end
  end

  def general_form_field_names
    form_field_names - association_fields.keys + foreign_keys_from_associations(belongs_to_associations)
  end

  def many_association_form_params
    many_associations.slice(*form_field_names).inject({}) do |params, (field_name, metadata)|
      params[metadata[:foreign_key]] = []
      params
    end
  end
end

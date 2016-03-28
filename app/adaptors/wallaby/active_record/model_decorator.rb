class Wallaby::ActiveRecord::ModelDecorator < Wallaby::ModelDecorator
  def collection(params = {})
    keyword = params.dup.delete :q
    query   = search_query_builder.build keyword
  end

  def find_or_initialize(id = nil, params = {})
    resource = if id.present?
      @model_class.where(primary_key => id).first or fail Wallaby::ResourceNotFound, id
    else
      @model_class.new
    end
    resource.assign_attributes params
    resource
  end

  def fields
    @fields ||= general_fields.merge(association_fields).except *foreign_keys_from_associations
  end

  def index_fields
    @index_fields ||= fields.deep_dup
  end

  def show_fields
    @show_fields  ||= fields.deep_dup
  end

  def form_fields
    @form_fields  ||= fields.deep_dup
  end

  def index_field_names
    @index_field_names ||= index_fields.reject do |field_name, metadata|
      metadata[:is_association] ||
      %w( text binary ).include?(metadata[:type])
    end.keys
  end

  def form_field_names
    @form_field_names ||= form_fields.reject do |field_name, metadata|
      %W( #{ primary_key } updated_at created_at ).include?(field_name) ||
      metadata[:has_scope] ||
      metadata[:is_through]
    end.keys
  end

  def param_key
    @model_class.model_name.param_key
  end

  def form_strong_param_names
    @form_strong_param_names ||= general_form_field_names + [ many_association_form_params ]
  end

  def form_active_errors(resource)
    resource.errors
  end

  def primary_key
    @model_class.primary_key
  end

  def guess_title(resource)
    resource.send title_field_finder.find
  end

  protected
  def field_builder
    @field_builder ||= Wallaby::ActiveRecord::ModelDecorator::FieldsBuilder.new @model_class
  end

  def search_query_builder
    @search_query_builder ||= Wallaby::ActiveRecord::ModelDecorator::SearchQueryBuilder.new @model_class, general_fields
  end

  def title_field_finder
    @title_field_finder ||= Wallaby::ActiveRecord::ModelDecorator::TitleFieldFinder.new @model_class, general_fields
  end

  delegate :general_fields, :association_fields, to: :field_builder

  def foreign_keys_from_associations(associations = association_fields)
    associations.inject([]) do |keys, (field_name, metadata)|
      keys << metadata[:foreign_key]      if metadata[:foreign_key]
      keys << metadata[:polymorphic_type] if metadata[:polymorphic_type]
      keys
    end
  end

  def many_associations(associations = association_fields)
    associations.select do |field_name, metadata|
      /many/ =~ metadata[:type] && !metadata[:is_through]
    end
  end

  def belongs_to_associations(associations = association_fields)
    associations.select do |field_name, metadata|
      'belongs_to' == metadata[:type]
    end
  end

  def general_form_field_names
    form_field_names - association_fields.keys \
      + foreign_keys_from_associations(belongs_to_associations)
  end

  def many_association_form_params(associations = many_associations, forms = form_field_names)
    associations.slice(*forms).inject({}) do |params, (field_name, metadata)|
      params[metadata[:foreign_key]] = []
      params
    end
  end
end

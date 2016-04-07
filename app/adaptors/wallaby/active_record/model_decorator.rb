class Wallaby::ActiveRecord::ModelDecorator < Wallaby::ModelDecorator
  def fields
    @fields ||= general_fields.merge(association_fields).except *foreign_keys_from_associations
  end

  def index_fields
    @index_fields ||= general_fields.merge(association_fields).except *foreign_keys_from_associations
  end

  def show_fields
    @show_fields  ||= general_fields.merge(association_fields).except *foreign_keys_from_associations
  end

  def form_fields
    @form_fields  ||= general_fields.merge(association_fields).except *foreign_keys_from_associations
  end

  def index_field_names
    @index_field_names ||= index_fields.reject do |field_name, metadata|
      metadata[:is_association] ||
      %w( binary citext json jsonb text tsvector xml ).include?(metadata[:type])
    end.keys
  end

  def form_field_names
    @form_field_names ||= form_fields.reject do |field_name, metadata|
      %W( #{ primary_key } updated_at created_at ).include?(field_name) ||
      metadata[:has_scope] ||
      metadata[:is_through]
    end.keys
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
end

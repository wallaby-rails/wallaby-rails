module Wallaby
  # Model Decorator interface, designed to maintain metadata information for all
  # the fields coming from data source (database/api)
  # @see Wallaby::ResourceDecorator for more information on how to customise
  #   metadata information
  class ModelDecorator
    attr_reader :model_class
    attr_writer \
      :field_names, :index_field_names, :show_field_names, :form_field_names

    def initialize(model_class)
      @model_class = model_class
    end

    # @return [Hash] metadata information for all fields that index/show/form
    #   will copy
    def fields
      raise NotImplemented
    end

    # @param fields [Hash] metadata information for all fields
    def fields=(fields)
      @fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array] field names
    def field_names
      @field_names ||= reposition fields.keys, primary_key
    end

    # @return [Hash] metadata information for a given field
    def metadata_of(field_name)
      fields[field_name] || {}
    end

    # @return [String] label for a given field
    def label_of(field_name)
      metadata_of(field_name)[:label]
    end

    # @return [String, Symbol] type for a given field
    def type_of(field_name)
      validate_presence_of metadata_of(field_name)[:type]
    end

    # @return [Hash] metadata information for all fields that would be used on
    #   index page
    def index_fields
      raise NotImplemented
    end

    # @param fields [Hash] metadata information for all fields that would be
    #   used on index page
    def index_fields=(fields)
      @index_fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array] field names of index page
    def index_field_names
      @index_field_names ||= reposition index_fields.keys, primary_key
    end

    # @return [Hash] index metadata information for a given field
    def index_metadata_of(field_name)
      index_fields[field_name] || {}
    end

    # @return [String] index label for a given field
    def index_label_of(field_name)
      index_metadata_of(field_name)[:label]
    end

    # @return [String, Symbol] index type for a given field
    def index_type_of(field_name)
      validate_presence_of index_metadata_of(field_name)[:type]
    end

    # @return [Hash] metadata information for all fields that would be used on
    #   show page
    def show_fields
      raise NotImplemented
    end

    # @param fields [Hash] metadata information for all fields that would be
    #   used on show page
    def show_fields=(fields)
      @show_fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array] field names of show page
    def show_field_names
      @show_field_names ||= reposition show_fields.keys, primary_key
    end

    # @return [Hash] show metadata information for a given field
    def show_metadata_of(field_name)
      show_fields[field_name] || {}
    end

    # @return [String] show label for a given field
    def show_label_of(field_name)
      show_metadata_of(field_name)[:label]
    end

    # @return [String, Symbol] show type for a given field
    def show_type_of(field_name)
      validate_presence_of show_metadata_of(field_name)[:type]
    end

    # @return [Hash] metadata information for all fields that would be used on
    #   form page
    def form_fields
      raise NotImplemented
    end

    # @param fields [Hash] metadata information for all fields that would be
    #   used on form page
    def form_fields=(fields)
      @form_fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array] field names of form page
    def form_field_names
      @form_field_names ||= reposition form_fields.keys, primary_key
    end

    # @return [Hash] form metadata information for a given field
    def form_metadata_of(field_name)
      form_fields[field_name] || {}
    end

    # @return [String] form label for a given field
    def form_label_of(field_name)
      form_metadata_of(field_name)[:label]
    end

    # @return [String, Symbol] form type for a given field
    def form_type_of(field_name)
      validate_presence_of form_metadata_of(field_name)[:type]
    end

    # @return [Hash] custom filters
    def filters
      @filters ||= ::ActiveSupport::HashWithIndifferentAccess.new
    end

    # @return [Hash] errors
    def form_active_errors(_resource)
      raise NotImplemented
    end

    # @return [String] primary key
    def primary_key
      raise NotImplemented
    end

    # @param _resource [Object] resource
    # @return [String] title of given resource
    def guess_title(_resource)
      raise NotImplemented
    end

    # @return [String] resources name mapped from model class
    def resources_name
      Map.resources_name_map @model_class
    end

    protected

    # @param field_names [Array] field names
    # @param primary_key [String] primary key name
    # @return [Array] a list of field names that primary key goes first
    def reposition(field_names, primary_key)
      field_names.unshift(primary_key).uniq
    end

    # Ensure type is present
    # @param type [String, Symbol, nil] type of a field
    # @return [String, Symbol] type name
    def validate_presence_of(type)
      type || raise(::ArgumentError, 'Type is required.')
    end
  end
end

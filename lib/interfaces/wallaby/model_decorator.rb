module Wallaby
  # Model Decorator interface, designed to maintain metadata information for all
  # the fields coming from data source (database/api)
  # @see Wallaby::ResourceDecorator for more information on how to customize
  #   metadata information
  class ModelDecorator
    include FieldHelpers

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
    def validate_presence_of(field_name, type)
      type || raise(::ArgumentError, "Type is required for #{field_name}.")
    end
  end
end

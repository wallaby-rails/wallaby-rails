module Wallaby
  # Model Decorator interface, designed to maintain metadata for all
  # the fields coming from data source (database/api)
  # @see Wallaby::ResourceDecorator for more information on how to customize
  #   metadata
  class ModelDecorator
    include FieldHelpers

    attr_reader :model_class
    attr_writer \
      :field_names, :index_field_names, :show_field_names, :form_field_names

    # Initialize with model class
    # @param model_class [Class] model class
    def initialize(model_class)
      @model_class = model_class
    end

    # @return [Hash] origin metadata for fields
    def fields
      raise NotImplemented
    end

    # Set metadata as origin
    # @param fields [Hash] metadata
    def fields=(fields)
      @fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array<String>, Array<Symbol>] a list of field names
    def field_names
      @field_names ||= reposition fields.keys, primary_key
    end

    # @return [Hash] metadata for fields used on index page
    def index_fields
      raise NotImplemented
    end

    # Set metadata for index page
    # @param fields [Hash] metadata
    def index_fields=(fields)
      @index_fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array<String>, Array<Symbol>]
    #   a list of field names displayed on index page
    def index_field_names
      @index_field_names ||= reposition index_fields.keys, primary_key
    end

    # @return [Hash] metadata for fields used on show page
    def show_fields
      raise NotImplemented
    end

    # Set metadata for show page
    # @param fields [Hash] metadata
    def show_fields=(fields)
      @show_fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array<String>, Array<Symbol>]
    #   a list of field names displayed on show page
    def show_field_names
      @show_field_names ||= reposition show_fields.keys, primary_key
    end

    # @return [Hash] metadata for fields used on form (new/edit) page
    def form_fields
      raise NotImplemented
    end

    # Set metadata for form (new/edit) page
    # @param fields [Hash] metadata
    def form_fields=(fields)
      @form_fields = ::ActiveSupport::HashWithIndifferentAccess.new fields
    end

    # @return [Array<String>, Array<Symbol>]
    #   a list field names displayed on form (new/edit) page
    def form_field_names
      @form_field_names ||= reposition form_fields.keys, primary_key
    end

    # @return [Hash] metadata for custom filters used on index page
    def filters
      @filters ||= ::ActiveSupport::HashWithIndifferentAccess.new
    end

    # @return [Hash] validation errors for current resource
    def form_active_errors(_resource)
      raise NotImplemented
    end

    # @return [String] primary key
    def primary_key
      raise NotImplemented
    end

    # To guess the title for a resource.
    #
    # This title will be used on the following places:
    # - page title on show page
    # - in the response for autocomplete association field
    # - title of show link for a resource
    # @param _resource [Object] resource
    # @return [String] title of current resource
    def guess_title(_resource)
      raise NotImplemented
    end

    # @return [String] resources name coverted from model class
    def resources_name
      Map.resources_name_map @model_class
    end

    protected

    # @param field_names [Array<String>, Array<Symbol>] field names
    # @param primary_key [String] primary key name
    # @return [Array<String>, Array<Symbol>]
    #   a list of field names that primary key goes first
    def reposition(field_names, primary_key)
      field_names.unshift(primary_key.to_s).uniq
    end

    # Ensure type is present
    # @param type [String, Symbol, nil] type of a field
    # @return [String, Symbol] type name
    def validate_presence_of(field_name, type)
      type || raise(::ArgumentError, "Type is required for #{field_name}.")
    end
  end
end

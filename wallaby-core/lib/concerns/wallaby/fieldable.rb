# frozen_string_literal: true

module Wallaby
  # Field helper method collection
  # that takes care of `fields`, `field_names` related methods for model decorator
  module Fieldable
    # @param field_name [String, Symbol] field name
    # @param prefix [String]
    # @return [ActiveSupport::HashWithIndifferentAccess] metadata
    def metadata_of(field_name, prefix = '')
      prefix_fields(prefix)[field_name] || {}
    end
    alias_method :prefix_metadata_of, :metadata_of

    # @param field_name [String, Symbol] field name
    # @param prefix [String]
    # @return [String] label for the given field
    def label_of(field_name, prefix = '')
      metadata_of(field_name, prefix)[:label] || field_name.to_s.humanize
    end
    alias_method :prefix_label_of, :label_of

    # @param field_name [String, Symbol] field name
    # @param prefix [String]
    # @return [String, Symbol] type for the given field
    def type_of(field_name, prefix = '')
      ensure_type_is_present field_name, metadata_of(field_name, prefix)[:type], prefix
    end
    alias_method :prefix_type_of, :type_of

    # @param prefix [String]
    # @return [ActiveSupport::HashWithIndifferentAccess] metadata
    def prefix_fields(prefix)
      variable = "@#{prefix}fields"
      instance_variable_get(variable) || instance_variable_set(variable, Utils.clone(fields))
    end

    # Set metadata for the given prefix
    # @param fields [Hash] fields metadata
    # @param prefix [String]
    # @return [ActiveSupport::HashWithIndifferentAccess] metadata
    def prefix_fields=(fields, prefix)
      variable = "@#{prefix}fields"
      instance_variable_set(variable, FieldsRegulator.new(fields).execute)
    end

    # @param prefix [String]
    # @return [Array<String>] a list of field names
    def prefix_field_names(prefix)
      variable = "@#{prefix}field_names"
      instance_variable_get(variable) || \
        instance_variable_set(variable, begin
          fields = prefix_fields(prefix).reject { |_k, metadata| metadata[:hidden] }
          reposition(fields.keys, primary_key)
        end)
    end

    # Set field names for the given prefix
    # @param field_names [Array<String>]
    # @param prefix [String]
    # @return [Array<String>] a list of field names
    def prefix_field_names=(field_names, prefix)
      variable = "@#{prefix}field_names"
      instance_variable_set(variable, Array.wrap(field_names).flatten)
    end
  end
end

# frozen_string_literal: true

module Wallaby
  # Validate and convert the field metadata to `ActiveSupport::HashWithIndifferentAccess`
  FieldsRegulator = Struct.new(:fields) do
    # @return [ActiveSupport::HashWithIndifferentAccess]
    def execute
      ensure_fields_is_a_hash
      ensure_type_is_present
      normalized_fields
    end

    protected

    def ensure_fields_is_a_hash
      return if fields.is_a?(Hash)

      raise ArgumentError, 'Please provide a Hash metadata'
    end

    def ensure_type_is_present
      missing_types = normalized_fields.select do |_field, metadata|
        metadata[:type].blank?
      end
      return if missing_types.blank?

      raise ArgumentError, "Please provide the type for #{missing_types.keys.join(',')}"
    end

    def normalized_fields
      @normalized_fields ||= fields.with_indifferent_access
    end
  end
end

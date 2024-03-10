# frozen_string_literal: true

module Wallaby
  # Field utils
  module FieldUtils
    class << self
      # Find the first field that meets the first condition.
      # @example to find the possible text field
      #   Wallaby::FieldUtils.first_field_by({ name: /name|title/ }, { type: 'string' }, fields)
      #   # => if any field name that includes `name` or `title`, return this field
      #   # => otherwise, find the first field whose type is `string`
      # @param conditions [Array<Hash>]
      # @param fields [Hash] field metadata
      # @return [String, Symbol] field name
      def first_field_by(*conditions, fields)
        return if [conditions, fields].any?(&:blank?)

        conditions.each do |condition|
          fields.each do |field_name, metadata|
            return field_name if meet? condition, field_name, metadata
          end
        end

        nil
      end

      protected

      # @param condition [Hash]
      # @param field_name [String]
      # @param metadata [Hash]
      # @return [true] if field's metadata meets the condition
      # @return [true] otherwise
      def meet?(condition, field_name, metadata)
        condition.all? do |key, requirement|
          value = metadata.with_indifferent_access[key]
          value ||= field_name.to_s if key.to_sym == :name
          value = value.to_s if value.is_a? Symbol
          requirement === value
        end
      end
    end
  end
end

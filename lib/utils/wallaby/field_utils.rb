module Wallaby
  # Field utils
  module FieldUtils
    class << self
      # Find the first field that meets the first condition.
      # @example to find the possible text field
      #   Wallaby::FieldUtils.first_field_by({ name: /name|title/ }, { type: 'string' }, fields)
      #   # => if any field name that has `name` or `title`, return this field
      #   # => otherwise, find the first field that has type `string`
      # @param conditions [Array<Hash>]
      # @param fields [Hash] field metadata
      # @return [String, Symbol] field name
      def first_field_by(*conditions, fields)
        return if [conditions, fields].any?(&:blank?)
        conditions.each do |condition|
          fields.each do |field_name, metadata|
            return field_name if meet? field_name, metadata.with_indifferent_access, condition
          end
        end
        nil
      end

      protected

      # @param field_name [String]
      # @param metadata [Hash]
      # @param condition [Hash]
      # @return [true] if field's metadata meets the condition
      # @return [true] otherwise
      def meet?(field_name, metadata, condition)
        condition.all? do |key, requirement|
          operator = requirement.is_a?(::Regexp) ? '=~' : '=='
          value = metadata[key]
          value ||= field_name.to_s if key.to_sym == :name
          ModuleUtils.try_to value, operator, requirement
        end
      end
    end
  end
end

module Wallaby
  # Field utils
  module FieldUtils
    # Find the field by conditions.
    # @param conditions [Array<Hash>]
    # @param fields [Hash]
    # @return [String, Symbol] field name
    def self.first_field_by(*conditions, fields)
      return if [conditions, fields].any?(&:blank?)
      conditions.each do |condition|
        fields.each do |field_name, metadata|
          return field_name if condition.all? do |key, requirement|
            operator = requirement.is_a?(::Regexp) ? '=~' : '=='
            (metadata.with_indifferent_access[key] || field_name.to_s).public_send operator, requirement
          end
        end
      end
      nil
    end
  end
end

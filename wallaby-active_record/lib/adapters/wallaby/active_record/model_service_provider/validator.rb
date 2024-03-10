# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Validate values for record create / update
      class Validator
        # @param model_decorator [Wallaby::ModelDecorator]
        def initialize(model_decorator)
          @model_decorator = model_decorator
        end

        # @param resource [Object] resource object
        # @return [true] if the resource object is valid
        # @return [false] otherwise
        def valid?(resource)
          resource.attributes.each do |field_name, values|
            metadata = @model_decorator.fields[field_name]
            next if valid_range_type? values, metadata

            resource.errors.add field_name, 'required for range data'
          end
          resource.errors.blank?
        end

        protected

        # @param values [Array]
        # @return [true] if the values are valid range values
        # @return [false] otherwise
        def valid_range_type?(values, metadata)
          !metadata \
            || %w[daterange tsrange tstzrange].exclude?(metadata[:type]) \
            || !values.try(:any?, &:blank?)
        end
      end
    end
  end
end

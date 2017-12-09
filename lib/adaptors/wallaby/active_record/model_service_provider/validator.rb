module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Validator
      class Validator
        def initialize(model_decorator)
          @model_decorator = model_decorator
        end

        def valid?(resource)
          resource.attributes.each do |field_name, values|
            metadata = @model_decorator.fields[field_name]
            next if valid_range_type? values, metadata
            resource.errors.add field_name, 'required for range data'
          end
          resource.errors.blank?
        end

        private

        def valid_range_type?(values, metadata)
          !metadata \
            || !%w(daterange tsrange tstzrange).include?(metadata[:type]) \
            || !values.try(:any?, &:blank?)
        end
      end
    end
  end
end

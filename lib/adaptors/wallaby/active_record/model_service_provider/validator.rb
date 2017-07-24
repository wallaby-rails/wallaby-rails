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
            next unless metadata
            next unless %w[daterange tsrange tstzrange].include? metadata[:type]
            next unless values.try(:any?, &:blank?)
            resource.errors.add field_name, 'required for range data'
          end
          resource.errors.blank?
        end
      end
    end
  end
end

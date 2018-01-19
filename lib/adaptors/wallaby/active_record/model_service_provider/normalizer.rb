module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Normalizer
      class Normalizer
        def initialize(model_decorator)
          @model_decorator = model_decorator
        end

        def normalize(params)
          params.each do |field_name, values|
            type = @model_decorator.type_of(field_name)
                                   .try(:[], /range|point|binary/)
            next unless type
            public_send "normalize_#{type}_values", params, field_name, values
          end
        end

        def normalize_range_values(params, field_name, values)
          normalized = Array(values).map(&:presence).compact
          params[field_name] =
            if normalized.present? && values.length == 2
              values.first...values.last
            end
        end

        def normalize_point_values(params, field_name, values)
          normalized = Array(values).map(&:presence).compact
          params[field_name] =
            normalized.present? &&
            values.map(&:to_f) || nil
        end

        def normalize_binary_values(params, field_name, values)
          params[field_name] =
            values.is_a?(::ActionDispatch::Http::UploadedFile) &&
            values.read || nil
        end
      end
    end
  end
end

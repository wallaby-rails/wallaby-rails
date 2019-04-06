module Wallaby
  class ActiveRecord
    class ModelServiceProvider
      # Normalize the values for a model
      class Normalizer
        # @param model_decorator [Wallaby::ModelDecorator]
        def initialize(model_decorator)
          @model_decorator = model_decorator
        end

        # @param params [ActionController::Parameters]
        def normalize(params)
          params.each do |field_name, values|
            metadata =
              @model_decorator.metadata_of(field_name).presence || @model_decorator.form_metadata_of(field_name)
            type = metadata[:type].try(:[], /range|point|binary/)
            next unless type
            public_send "normalize_#{type}_values", params, field_name, values
          end
          params
        end

        # Turn values into range
        # @param params [ActionController::Parameters]
        # @param field_name [String]
        # @param values [Array]
        def normalize_range_values(params, field_name, values)
          normalized = Array(values).map(&:presence).compact
          params[field_name] = (normalized.present? && values.length == 2) && (values.first...values.last) || nil
        end

        # Turn values into points
        # @param params [ActionController::Parameters]
        # @param field_name [String]
        # @param values [Array]
        def normalize_point_values(params, field_name, values)
          normalized = Array(values).map(&:presence).compact
          params[field_name] = normalized.present? && values.map(&:to_f) || nil
        end

        # Turn values into binary
        # @param params [ActionController::Parameters]
        # @param field_name [String]
        # @param values [Object]
        def normalize_binary_values(params, field_name, values)
          params[field_name] = values.is_a?(::ActionDispatch::Http::UploadedFile) && values.read || nil
        end
      end
    end
  end
end

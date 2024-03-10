# frozen_string_literal: true

module Wallaby
  class ActiveRecord
    class ModelDecorator
      # Try to find the field that can be used as title
      class TitleFieldFinder
        TITLE_FIELD_TYPES = %w[string].freeze

        # @param model_class [Class]
        # @param fields [Hash] fields metadata
        def initialize(model_class, fields)
          @model_class  = model_class
          @fields       = fields
        end

        # @return [String] field name that can be used as title
        def find
          FieldUtils.first_field_by(
            {
              name: /title|name|label|string/,
              type: 'string'
            }, @fields
          ) || @model_class.primary_key
        end
      end
    end
  end
end

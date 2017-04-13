module Wallaby
  module ActiveRecord
    module ModelDecorator
      # Try to find the field that can be used as title
      class TitleFieldFinder
        TITLE_FIELD_TYPES = %w[string].freeze
        TITLE_NAMES = %w[name title string text].freeze

        def initialize(model_class, fields)
          @model_class  = model_class
          @fields       = fields
        end

        def find
          possible_title_fields = @fields.select do |_field_name, metadata|
            TITLE_FIELD_TYPES.include? metadata[:type]
          end
          target_field = possible_title_fields.values.find do |metadata|
            TITLE_NAMES.any? { |v| metadata[:name].index v }
          end
          target_field ||= possible_title_fields.values.first
          target_field ||= { name: @model_class.primary_key }
          target_field[:name]
        end
      end
    end
  end
end

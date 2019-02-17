module Wallaby
  module Resources
    module Index
      class DatetimeHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          if value.nil?
            null
          else
            value = Time.zone.parse value if value.is_a? String
            concat content_tag(:span, I18n.l(value, format: :short))
            itooltip I18n.l(value), 'clock-o'
          end
        end
      end
    end
  end
end

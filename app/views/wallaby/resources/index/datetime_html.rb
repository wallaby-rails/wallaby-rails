module Wallaby
  module Resources
    module Index
      class DatetimeHtml < Cell
        def render
          if value.nil?
            null
          else
            self.value = Time.zone.parse value if value.is_a? String
            concat content_tag(:span, I18n.l(value, format: :short))
            itooltip I18n.l(value), 'clock-o'
          end
        end
      end
    end
  end
end
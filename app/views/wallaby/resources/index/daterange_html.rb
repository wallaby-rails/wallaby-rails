module Wallaby
  module Resources
    module Index
      # Html cell
      class DaterangeHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            concat content_tag(:span, I18n.l(value.first, format: :short), class: 'from')
            concat '...'
            concat content_tag(:span, I18n.l(value.last, format: :short), class: 'to')
            itooltip "#{I18n.l value.first} ... #{I18n.l value.last}", 'time'
          end
        end
      end
    end
  end
end

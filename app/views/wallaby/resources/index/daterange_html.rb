module Wallaby
  module Resources
    module Index
      class DaterangeHtml < Renderer
        def render
          if value.nil?
            null
          else
            concat content_tag(:span, I18n.l(value.first, format: :short))
            concat '...'
            concat content_tag(:span, I18n.l(value.last, format: :short))
            itooltip "#{ I18n.l value.first } ... #{ I18n.l value.last }", 'clock-o'
          end
        end
      end
    end
  end
end

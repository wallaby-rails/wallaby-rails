module Wallaby
  module Resources
    module Index
      class ColorHtml < Cell
        def render
          if value.nil?
            null
          else
            concat content_tag(:span, nil, style: "background-color: #{value};", class: 'color-square')
            content_tag(:span, value, class: 'text-uppercase')
          end
        end
      end
    end
  end
end

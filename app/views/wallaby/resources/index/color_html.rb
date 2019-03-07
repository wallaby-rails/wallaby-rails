module Wallaby
  module Resources
    module Index
      # Html cell
      class ColorHtml < Cell
        # @return [String]
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

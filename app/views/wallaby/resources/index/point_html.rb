module Wallaby
  module Resources
    module Index
      class PointHtml < Cell
        def render
          if value.nil?
            null
          else
            concat '('
            concat content_tag(:span, value[0], class: 'x')
            concat ', '
            concat content_tag(:span, value[1], class: 'y')
            ')'
          end
        end
      end
    end
  end
end

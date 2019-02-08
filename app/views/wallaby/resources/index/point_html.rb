module Wallaby
  module Resources
    module Index
      class PointHtml < Renderer
        def render
          if value.nil?
            null
          else
            concat '('
            concat content_tag(:span, value[0], class: 'x')
            concat content_tag(:span, value[1], class: 'y')
            concat ')'
          end
        end
      end
    end
  end
end

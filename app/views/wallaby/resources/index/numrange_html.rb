module Wallaby
  module Resources
    module Index
      class NumrangeHtml < Renderer
        def render
          if value.nil?
            null
          else
            concat content_tag(:span, value.first, class: 'from')
            concat '...'
            concat content_tag(:span, value.last, class: 'to')
          end
        end
      end
    end
  end
end

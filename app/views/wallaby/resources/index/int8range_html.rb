module Wallaby
  module Resources
    module Index
      class Int8rangeHtml < Cell
        def render(object:, field_name:, value:, metadata:)
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

module Wallaby
  module Resources
    module Index
      class LineHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          if value.nil?
            null
          else
            max = metadata[:max] || default_metadata.max
            value = value.to_s
            if value.length > max
              concat content_tag(:code, value.truncate(max))
              itooltip value
            else
              content_tag :code, value
            end
          end
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class PolygonHtml < Cell
        def render
          if value.nil?
            null
          else
            max = metadata[:max] || default_metadata.max
            self.value = value.to_s
            if value.length > max
              concat content_tag(:code, value.truncate(max))
              imodal metadata[:label], value
            else
              content_tag :code, value
            end
          end
        end
      end
    end
  end
end
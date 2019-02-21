module Wallaby
  module Resources
    module Index
      class CitextHtml < Cell
        def render
          if value.nil?
            null
          else
            max = metadata[:max] || default_metadata.max
            self.value = value.to_s
            if value.length > max
              concat content_tag(:span, value.truncate(max))
              imodal metadata[:label], value
            else
              value
            end
          end
        end
      end
    end
  end
end

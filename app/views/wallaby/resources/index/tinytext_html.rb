module Wallaby
  module Resources
    module Index
      class TinytextHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          if value.nil?
            null
          else
            max = metadata[:max] || default_metadata.max
            value = value.to_s
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

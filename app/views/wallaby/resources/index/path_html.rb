module Wallaby
  module Resources
    module Index
      class PathHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          if value.nil?
            null
          else
            max = metadata[:max] || default_metadata.max
            value = value.to_s
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

module Wallaby
  module Resources
    module Index
      class BitHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          if value.nil?
            null
          else
            content_tag :code, value
          end
        end
      end
    end
  end
end

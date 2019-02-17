module Wallaby
  module Resources
    module Index
      class TinyblobHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value ? muted('tinyblob') : null
        end
      end
    end
  end
end

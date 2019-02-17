module Wallaby
  module Resources
    module Index
      class LongblobHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value ? muted('longblob') : null
        end
      end
    end
  end
end

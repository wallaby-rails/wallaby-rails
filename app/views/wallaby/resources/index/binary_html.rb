module Wallaby
  module Resources
    module Index
      class BinaryHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value ? muted('binary') : null
        end
      end
    end
  end
end

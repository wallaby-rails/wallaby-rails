module Wallaby
  module Resources
    module Index
      class BinaryHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          value ? muted('binary') : null
        end
      end
    end
  end
end

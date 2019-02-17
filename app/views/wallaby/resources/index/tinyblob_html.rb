module Wallaby
  module Resources
    module Index
      class TinyblobHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          value ? muted('tinyblob') : null
        end
      end
    end
  end
end

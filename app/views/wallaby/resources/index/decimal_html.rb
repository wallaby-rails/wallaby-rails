module Wallaby
  module Resources
    module Index
      class DecimalHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          value || null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class IntegerHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          value.try(:to_i) || null
        end
      end
    end
  end
end

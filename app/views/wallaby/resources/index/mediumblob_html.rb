module Wallaby
  module Resources
    module Index
      class MediumblobHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          value ? muted('mediumblob') : null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class FloatHtml < Cell
        def render
          value.try(:to_f) || null
        end
      end
    end
  end
end

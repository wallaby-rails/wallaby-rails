module Wallaby
  module Resources
    module Index
      # Html cell
      class FloatHtml < Cell
        # @return [String]
        def render
          value.try(:to_f) || null
        end
      end
    end
  end
end

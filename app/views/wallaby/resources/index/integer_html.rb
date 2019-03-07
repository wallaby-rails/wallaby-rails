module Wallaby
  module Resources
    module Index
      # Html cell
      class IntegerHtml < Cell
        # @return [String]
        def render
          value.try(:to_i) || null
        end
      end
    end
  end
end

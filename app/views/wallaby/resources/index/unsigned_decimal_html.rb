module Wallaby
  module Resources
    module Index
      # Html cell
      class UnsignedDecimalHtml < Cell
        # @return [String]
        def render
          value || null
        end
      end
    end
  end
end

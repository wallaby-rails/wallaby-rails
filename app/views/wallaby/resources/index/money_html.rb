module Wallaby
  module Resources
    module Index
      # Html cell
      class MoneyHtml < Cell
        # @return [String]
        def render
          value || null
        end
      end
    end
  end
end

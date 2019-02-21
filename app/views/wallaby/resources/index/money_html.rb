module Wallaby
  module Resources
    module Index
      class MoneyHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

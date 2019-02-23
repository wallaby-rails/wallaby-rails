module Wallaby
  module Resources
    module Index
      class DecimalHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

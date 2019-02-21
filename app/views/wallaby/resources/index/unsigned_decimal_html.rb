module Wallaby
  module Resources
    module Index
      class UnsignedDecimalHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

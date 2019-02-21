module Wallaby
  module Resources
    module Index
      class UnsignedBigintHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

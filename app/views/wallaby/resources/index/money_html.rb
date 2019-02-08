module Wallaby
  module Resources
    module Index
      class MoneyHtml < Renderer
        def render
          value || null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class DecimalHtml < Renderer
        def render
          value || null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class UnsignedDecimalHtml < Renderer
        def render
          value || null
        end
      end
    end
  end
end

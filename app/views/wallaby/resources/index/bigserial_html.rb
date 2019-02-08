module Wallaby
  module Resources
    module Index
      class BigserialHtml < Renderer
        def render
          value || null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class SerialHtml < Renderer
        def render
          value || null
        end
      end
    end
  end
end

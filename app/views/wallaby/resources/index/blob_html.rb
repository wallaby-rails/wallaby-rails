module Wallaby
  module Resources
    module Index
      class BlobHtml < Renderer
        def render
          value ? muted('blob') : null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class TinyblobHtml < Renderer
        def render
          value ? muted('tinyblob') : null
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class LongblobHtml < Renderer
        def render
          value ? muted('longblob') : null
        end
      end
    end
  end
end

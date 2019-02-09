module Wallaby
  module Resources
    module Index
      class BlobHtml < Cell
        def render
          value ? muted('blob') : null
        end
      end
    end
  end
end

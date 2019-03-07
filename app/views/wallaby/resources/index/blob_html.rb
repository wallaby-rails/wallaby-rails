module Wallaby
  module Resources
    module Index
      # Html cell
      class BlobHtml < Cell
        # @return [String]
        def render
          value ? muted('blob') : null
        end
      end
    end
  end
end

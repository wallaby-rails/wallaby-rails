module Wallaby
  module Resources
    module Index
      # Html cell
      class LongblobHtml < Cell
        # @return [String]
        def render
          value ? muted('longblob') : null
        end
      end
    end
  end
end

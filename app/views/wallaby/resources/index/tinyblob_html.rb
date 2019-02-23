module Wallaby
  module Resources
    module Index
      class TinyblobHtml < Cell
        def render
          value ? muted('tinyblob') : null
        end
      end
    end
  end
end

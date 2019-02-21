module Wallaby
  module Resources
    module Index
      class BinaryHtml < Cell
        def render
          value ? muted('binary') : null
        end
      end
    end
  end
end

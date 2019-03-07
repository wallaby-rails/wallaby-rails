module Wallaby
  module Resources
    module Index
      # Html cell
      class BinaryHtml < Cell
        # @return [String]
        def render
          value ? muted('binary') : null
        end
      end
    end
  end
end

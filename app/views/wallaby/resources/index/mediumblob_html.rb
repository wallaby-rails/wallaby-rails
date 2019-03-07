module Wallaby
  module Resources
    module Index
      # Html cell
      class MediumblobHtml < Cell
        # @return [String]
        def render
          value ? muted('mediumblob') : null
        end
      end
    end
  end
end

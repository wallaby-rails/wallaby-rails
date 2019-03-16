module Wallaby
  module Resources
    module Index
      # Html cell
      class BooleanHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            value ? fa_icon('check-square') : fa_icon('square')
          end
        end
      end
    end
  end
end

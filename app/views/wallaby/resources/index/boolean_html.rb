module Wallaby
  module Resources
    module Index
      class BooleanHtml < Cell
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

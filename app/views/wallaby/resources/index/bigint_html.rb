module Wallaby
  module Resources
    module Index
      class BigintHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

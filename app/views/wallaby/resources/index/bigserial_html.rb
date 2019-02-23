module Wallaby
  module Resources
    module Index
      class BigserialHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

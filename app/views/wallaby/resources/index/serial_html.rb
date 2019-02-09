module Wallaby
  module Resources
    module Index
      class SerialHtml < Cell
        def render
          value || null
        end
      end
    end
  end
end

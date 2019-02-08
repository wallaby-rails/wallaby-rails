module Wallaby
  module Resources
    module Index
      class MediumblobHtml < Renderer
        def render
          value ? muted('mediumblob') : null
        end
      end
    end
  end
end

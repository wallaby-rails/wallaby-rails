module Wallaby
  module Resources
    module Index
      class BinaryHtml < Renderer
        def render
          value ? muted('binary') : null
        end
      end
    end
  end
end

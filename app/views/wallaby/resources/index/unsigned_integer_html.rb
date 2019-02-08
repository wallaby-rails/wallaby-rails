module Wallaby
  module Resources
    module Index
      class UnsignedIntegerHtml < Renderer
        def render
          value.try(:to_i) || null
        end
      end
    end
  end
end

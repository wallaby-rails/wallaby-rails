module Wallaby
  module Resources
    module Index
      class UnsignedFloatHtml < Renderer
        def render
          value.try(:to_f) || null
        end
      end
    end
  end
end

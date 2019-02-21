module Wallaby
  module Resources
    module Index
      class UnsignedFloatHtml < Cell
        def render
          value.try(:to_f) || null
        end
      end
    end
  end
end

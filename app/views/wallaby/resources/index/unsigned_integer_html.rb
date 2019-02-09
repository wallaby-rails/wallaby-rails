module Wallaby
  module Resources
    module Index
      class UnsignedIntegerHtml < Cell
        def render
          value.try(:to_i) || null
        end
      end
    end
  end
end

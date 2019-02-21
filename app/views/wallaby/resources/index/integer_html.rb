module Wallaby
  module Resources
    module Index
      class IntegerHtml < Cell
        def render
          value.try(:to_i) || null
        end
      end
    end
  end
end

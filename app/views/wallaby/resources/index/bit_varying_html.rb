module Wallaby
  module Resources
    module Index
      class BitVaryingHtml < Cell
        def render
          if value.nil?
            null
          else
            content_tag :code, value
          end
        end
      end
    end
  end
end

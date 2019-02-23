module Wallaby
  module Resources
    module Index
      class RawHtml < Cell
        def render
          if value.nil?
            null
          else
            value.html_safe
          end
        end
      end
    end
  end
end

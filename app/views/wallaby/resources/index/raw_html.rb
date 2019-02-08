module Wallaby
  module Resources
    module Index
      class RawHtml < Renderer
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

module Wallaby
  module Resources
    module Index
      class BitHtml < Renderer
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

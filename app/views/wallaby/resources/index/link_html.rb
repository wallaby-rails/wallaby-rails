module Wallaby
  module Resources
    module Index
      class LinkHtml < Renderer
        def render
          value.nil? ? null : link_to(metadata[:title], value, metadata[:html_options])
        end
      end
    end
  end
end

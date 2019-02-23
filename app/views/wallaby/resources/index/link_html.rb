module Wallaby
  module Resources
    module Index
      class LinkHtml < Cell
        def render
          value.nil? ? null : link_to(metadata[:title], value, metadata[:html_options])
        end
      end
    end
  end
end

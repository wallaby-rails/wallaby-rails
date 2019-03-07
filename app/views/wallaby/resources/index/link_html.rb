module Wallaby
  module Resources
    module Index
      # Html cell
      class LinkHtml < Cell
        # @return [String]
        def render
          value.nil? ? null : link_to(metadata[:title], value, metadata[:html_options])
        end
      end
    end
  end
end

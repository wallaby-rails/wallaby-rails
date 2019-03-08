module Wallaby
  module Resources
    module Index
      # Html cell
      class InetHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            concat content_tag(:code, value)
            link_to(
              glyph_icon('link'), "http://ip-api.com/##{value}",
              target: :_blank, class: 'text-info'
            )
          end
        end
      end
    end
  end
end

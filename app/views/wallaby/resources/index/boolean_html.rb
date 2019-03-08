module Wallaby
  module Resources
    module Index
      # Html cell
      class BooleanHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            value ? glyph_icon('check') : glyph_icon('uncheck')
          end
        end
      end
    end
  end
end

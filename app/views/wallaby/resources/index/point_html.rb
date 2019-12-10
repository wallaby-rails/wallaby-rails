# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class PointHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            concat '('
            concat content_tag(:span, value[0], class: 'x')
            concat ', '
            concat content_tag(:span, value[1], class: 'y')
            ')'
          end
        end
      end
    end
  end
end

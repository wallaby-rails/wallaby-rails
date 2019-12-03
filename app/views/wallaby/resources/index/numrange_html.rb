# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class NumrangeHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            concat content_tag(:span, value.first, class: 'from')
            concat '...'
            concat content_tag(:span, value.last, class: 'to')
          end
        end
      end
    end
  end
end

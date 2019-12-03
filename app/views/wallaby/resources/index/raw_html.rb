# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class RawHtml < Cell
        # @return [String]
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

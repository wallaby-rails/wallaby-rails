# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class MacaddrHtml < Cell
        # @return [String]
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

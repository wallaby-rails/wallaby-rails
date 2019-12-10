# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class TinyblobHtml < Cell
        # @return [String]
        def render
          value ? muted('tinyblob') : null
        end
      end
    end
  end
end

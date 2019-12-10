# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class HasOneHtml < Cell
        # @return [String]
        def render
          value.present? ? show_link(value, options: { readonly: true }) : null
        end
      end
    end
  end
end

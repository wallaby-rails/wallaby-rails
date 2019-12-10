# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class EmailHtml < Cell
        # @return [String]
        def render
          value.nil? ? null : mail_to(value)
        end
      end
    end
  end
end

# frozen_string_literal: true

module Wallaby
  module Resources
    module Index
      # Html cell
      class TimeHtml < Cell
        # @return [String]
        def render
          if value.nil?
            null
          else
            self.value = Time.zone.parse value if value.is_a? String
            I18n.l value, format: '%H:%M:%S'
          end
        end
      end
    end
  end
end

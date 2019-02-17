module Wallaby
  module Resources
    module Index
      class TimeHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          if value.nil?
            null
          else
            value = Time.zone.parse value if value.is_a? String
            I18n.l value, format: '%H:%M:%S'
          end
        end
      end
    end
  end
end

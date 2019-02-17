module Wallaby
  module Resources
    module Index
      class DateHtml < Cell
        def render(object:, field_name:, value:, metadata:)
          if value.nil?
            null
          else
            value = Time.zone.parse value if value.is_a? String
            value = value.to_date if value.is_a? Time
            I18n.l value
          end
        end
      end
    end
  end
end

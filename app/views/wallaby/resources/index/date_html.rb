module Wallaby
  module Resources
    module Index
      class DateHtml < Renderer
        def render
          if value.nil?
            null
          else
            self.value = Time.zone.parse value if value.is_a? String
            self.value = value.to_date if value.is_a? Time
            I18n.l value
          end
        end
      end
    end
  end
end

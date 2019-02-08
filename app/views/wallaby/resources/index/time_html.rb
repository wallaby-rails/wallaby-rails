module Wallaby
  module Resources
    module Index
      class TimeHtml < Renderer
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

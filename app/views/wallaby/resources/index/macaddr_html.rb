module Wallaby
  module Resources
    module Index
      class MacaddrHtml < Cell
        def render(object:, field_name:, value:, metadata:)
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

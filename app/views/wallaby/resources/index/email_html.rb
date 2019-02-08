module Wallaby
  module Resources
    module Index
      class EmailHtml < Renderer
        def render
          value.nil? ? null : mail_to(value)
        end
      end
    end
  end
end

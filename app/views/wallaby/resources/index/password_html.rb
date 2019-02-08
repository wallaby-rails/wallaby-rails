module Wallaby
  module Resources
    module Index
      class PasswordHtml < Renderer
        def render
          if value.nil?
            null
          else
            content_tag :span, '********'
          end
        end
      end
    end
  end
end

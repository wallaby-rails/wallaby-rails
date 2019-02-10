module Wallaby
  module Resources
    module Index
      class PasswordHtml < Cell
        def render
          if value.nil?
            null
          else
            content_tag :code, '********'
          end
        end
      end
    end
  end
end

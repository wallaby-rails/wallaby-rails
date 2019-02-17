module Wallaby
  module Resources
    module Index
      class PasswordHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
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

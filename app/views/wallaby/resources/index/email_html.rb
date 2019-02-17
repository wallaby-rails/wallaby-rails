module Wallaby
  module Resources
    module Index
      class EmailHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value.nil? ? null : mail_to(value)
        end
      end
    end
  end
end

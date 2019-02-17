module Wallaby
  module Resources
    module Index
      class MediumblobHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value ? muted('mediumblob') : null
        end
      end
    end
  end
end

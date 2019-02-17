module Wallaby
  module Resources
    module Index
      class LinkHtml < Cell
        def render(object:, field_name:, value:, metadata:) # rubocop:disable Lint/UnusedMethodArgument
          value.nil? ? null : link_to(metadata[:title], value, metadata[:html_options])
        end
      end
    end
  end
end

module Wallaby
  module Resources
    module Index
      class BelongsToHtml < Cell
        def render
          value.present? ? show_link(value, options: { readonly: true }) : null
        end
      end
    end
  end
end

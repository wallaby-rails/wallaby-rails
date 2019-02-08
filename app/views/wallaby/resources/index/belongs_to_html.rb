module Wallaby
  module Resources
    module Index
      class BelongsToHtml < Renderer
        def render
          value.present? ? show_link(value, options: { readonly: true }) : null
        end
      end
    end
  end
end

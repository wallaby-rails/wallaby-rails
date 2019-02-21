module Wallaby
  # Custom view renderer to replace the origin Rails view renderer
  class CustomRenderer < ::ActionView::Renderer
    # Direct access to partial rendering.
    def render_partial(context, options, &block) #:nodoc:
      CustomPartialRenderer.new(lookup_context).render(context, options, block)
    end
  end
end

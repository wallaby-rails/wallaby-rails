module Wallaby
  # Custom view renderer to provide support for cell rendering
  class CustomRenderer < ::ActionView::Renderer
    # @return [String] HTML output
    # @see Wallaby::CustomPartialRenderer
    def render_partial(context, options, &block) #:nodoc:
      CustomPartialRenderer.new(lookup_context).render(context, options, block)
    end
  end
end

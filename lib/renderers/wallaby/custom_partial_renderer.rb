module Wallaby
  # Custom partial renderer to provide support for cell rendering
  class CustomPartialRenderer < ::ActionView::PartialRenderer
    # When a type partial is found, it works as usual.
    #
    # But when a cell is found, there is an exception {Wallaby::CellHandling} raised. This error will be captured,
    # and the cell will be rendered.
    # @param context [ActionView::Context]
    # @param options [Hash]
    # @param block [Proc]
    # @return [String] HTML output
    def render(context, options, block)
      super
    rescue CellHandling => e
      CellUtils.render context, e.message, options[:locals], &block
    end

    # Override origin method to stop rendering when a cell is found.
    # @return [ActionView::Template] partial template
    # @raise [Wallaby:::CellHandling] when a cell is found
    def find_partial(*)
      super.tap do |partial|
        raise CellHandling, partial.inspect if CellUtils.cell? partial.inspect
      end
    end
  end
end

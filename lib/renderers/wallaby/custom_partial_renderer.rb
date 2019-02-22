module Wallaby
  # Custom view renderer to provide support for cell rendering
  class CustomPartialRenderer < ::ActionView::PartialRenderer
    # Render a cell
    # @param context [ActionView::Context]
    # @param options [Hash]
    # @param block [Proc]
    def render(context, options, block)
      super
    rescue CellHandling => e
      CellUtils.render context, e.message, options[:locals], &block
    end

    # Override origin method to stop rendering when a cell is found.
    # @raise [Wallaby:::CellHandling] when a cell is found
    def find_partial(*)
      super.tap do |partial|
        raise CellHandling, partial.inspect if CellUtils.cell? partial.inspect
      end
    end
  end
end

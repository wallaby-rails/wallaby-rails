module Wallaby
  # Custom view renderer to replace the origin Rails view renderer
  class CustomPartialRenderer < ::ActionView::PartialRenderer
    # Direct access to partial rendering.
    def render(context, options, block)
      super
    rescue CellHandling => e
      render_cell context, e.message, options, block
    end

    def find_partial(*)
      super.tap do |partial|
        raise CellHandling, partial.inspect if partial.inspect.end_with? '.rb'
      end
    end

    def render_cell(context, file_name, options, block)
      snake_class = file_name[%r{(?<=/app/).+(?=\.rb)}].split('/', 2).last
      cell_class = snake_class.camelize.constantize
      Rails.logger.debug "  Rendered [cell] #{file_name}"
      cell_class.new(context, options[:locals]).render_complete(&block)
    end
  end
end

module Wallaby
  # Cell utils
  class CellUtils
    class << self
      # Render cell
      # @param view [ActionView::Context]
      # @param file_name [String]
      # @param locals [Hash]
      # @return [String] HTML output
      def render(view, file_name, locals = {}, &block)
        snake_class = file_name[%r{(?<=/app/).+(?=\.rb)}].split(SLASH, 2).last
        cell_class = snake_class.camelize.constantize
        Rails.logger.debug "  Rendered [cell] #{file_name}"
        cell_class.new(view, locals).render_complete(&block)
      end

      # Check if a partial is a cell?
      # @param full_partial_path [String]
      # @return [true] if partial is a `rb` file
      # @return [false] otherwise
      def cell?(full_partial_path)
        full_partial_path.end_with? '.rb'
      end
    end
  end
end

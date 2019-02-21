module Wallaby
  # @!visibility private
  # Cell renderer
  class CellRenderer
    class << self
      # Render cell
      # @param view [ActionView]
      # @param file_name [String]
      # @param locals [Hash]
      # @return [String] HTML
      def render(view, file_name, locals = {}, &block)
        snake_class = file_name[%r{(?<=/app/).+(?=\.rb)}].split('/', 2).last
        cell_class = snake_class.camelize.constantize
        Rails.logger.debug "  Rendered [cell] #{file_name}"
        cell_class.new(view, locals).render_complete(&block)
      end
    end
  end
end

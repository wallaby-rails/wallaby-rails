# frozen_string_literal: true

module Wallaby
  module Resources
    # Html cell
    class ResourceActionsHtml < Cell
      # @return [String]
      def render
        concat(show_link(local_assigns[:decorated]) {})
        concat(edit_link(local_assigns[:decorated]) {})
        delete_link(local_assigns[:decorated]) {}
      end
    end
  end
end

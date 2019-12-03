# frozen_string_literal: true

module Wallaby
  module Resources
    # Html cell
    class ActiveStorageHtml < Cell
      # @return [String]
      def render
        value.try(:attachment) ? link_to(value.attachment.blob.filename, rails_blob_path(value)) : null
      end
    end
  end
end

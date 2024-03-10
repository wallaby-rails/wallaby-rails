# frozen_string_literal: true

require 'csv'

module Wallaby
  # Resources responder
  class ResourcesResponder < ActionController::Responder
    include ::Responders::FlashResponder

    # Render CSV with a file name that contains export timestamp.
    def to_csv
      controller.headers['Content-Disposition'] = "attachment; filename=\"#{file_name_to_export}\""
      default_render
    end

    protected

    # @return [String] file name with export timestamp
    def file_name_to_export
      timestamp = Time.zone.now.try do |t|
        t.respond_to?(:to_fs) ? t.to_fs(:number) : t.to_s(:number)
      end
      filename =
        (request.params[:resources] || controller.controller_path)
        .gsub(/#{SLASH}|#{COLONS}/o, HYPHEN)
      "#{filename}-exported-#{timestamp}.#{format}"
    end

    # @return [Boolean] true if there is exception or resource has errors
    # @return [Boolean] false otherwise
    def has_errors?
      resource.nil? || resource.is_a?(Exception) || controller.decorate(resource).errors.present?
    end
  end
end

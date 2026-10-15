# frozen_string_literal: true

require 'csv'

module Wallaby
  # Resources responder
  class ResourcesResponder < ActionController::Responder
    include ::Responders::FlashResponder

    class << self
      # SECURITY: keep only characters that are safe inside a
      # `Content-Disposition` token so a request-derived name cannot inject
      # header content (CRLF/quote).
      # @param name [Object]
      # @return [String]
      def sanitize_file_name(name)
        name.to_s.gsub(/[^0-9A-Za-z_.-]/, HYPHEN)
      end
    end

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
      "#{self.class.sanitize_file_name(filename)}-exported-#{timestamp}.#{format}"
    end

    # @return [Boolean] true if there is exception or resource has errors
    # @return [Boolean] false otherwise
    def has_errors?
      resource.nil? || resource.is_a?(Exception) || controller.decorate(resource).errors.present?
    end
  end
end

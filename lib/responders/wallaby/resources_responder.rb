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
      timestamp = Time.zone.now.to_s(:number)
      "#{request.params[:resources]}-exported-#{timestamp}.#{format}"
    end

    # @return [Boolean] true if there is exception or resource has errors
    # @return [Boolean] false otherwise
    def has_errors? # rubocop:disable Naming/PredicateName
      resource.nil? || resource.is_a?(Exception) || controller.decorate(resource).errors.present?
    end
  end
end

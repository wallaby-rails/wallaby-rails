module Wallaby
  # Wallaby resource responder
  class ResourcesResponder < ActionController::Responder
    include ::Responders::FlashResponder

    # @return [String] CSV
    def to_csv
      controller.headers['Content-Disposition'] = "attachment; filename=\"#{file_name_to_export}\""
      default_render
    end

    protected

    # @return [String] file name
    def file_name_to_export
      timestamp = Time.zone.now.to_s(:number)
      "#{request.params[:resources]}-exported-#{timestamp}.#{format}"
    end

    def has_errors? # rubocop:disable Naming/PredicateName
      resource.nil? || resource.is_a?(Exception) || controller.decorate(resource).errors.present?
    end
  end
end

module Wallaby
  # Abstract responder
  class AbstractResponder < ActionController::Responder
    include ::Responders::FlashResponder

    # @return [String] CSV
    def to_csv
      controller.headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
      default_render
    end

    protected

    # @return [String] file name
    def file_name
      timestamp = Time.zone.now.to_s(:number)
      "#{request.params[:resources]}-exported-#{timestamp}.#{format}"
    end

    def has_errors? # rubocop:disable Naming/PredicateName
      resource.nil? || resource.is_a?(Exception) || controller.decorate(resource).errors.present?
    end
  end
end

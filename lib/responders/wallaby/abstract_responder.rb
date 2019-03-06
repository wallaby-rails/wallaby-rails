module Wallaby
  # Abstract responder
  class AbstractResponder < ActionController::Responder
    include ::Responders::FlashResponder

    delegate :params, :headers, to: :request

    # @return [String] HTML
    def to_html
      set_flash_message
      return render options if exception?
      if post? then create_action
      elsif patch? || put? then update_action
      elsif delete? then destroy_action
      else default_render
      end
    end

    # @return [String] CSV
    def to_csv
      set_layout_to_none
      headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
      default_render
    end

    # @return [String] JSON
    def to_json
      set_layout_to_none
      return default_render unless post? || patch? || put? || delete?
      if has_errors? then render :bad_request, options.merge(status: :bad_request)
      else render :form, options
      end
    end

    private

    # For create action
    # - if has errors, render the form again
    # - else redirect to show page
    def create_action
      if has_errors?
        render :new, options
      else
        redirect_to resource_location
      end
    end

    # For update action
    # - if has errors, render the form again
    # - else redirect to show page
    def update_action
      if has_errors?
        render :edit, options
      else
        redirect_to resource_location
      end
    end

    # For destroy action
    # - redirect to show page
    def destroy_action
      redirect_to resource_location
    end

    # @return [String] file name
    def file_name
      timestamp = Time.zone.now.to_s(:number)
      "#{params[:resources]}-exported-#{timestamp}.#{format}"
    end

    # Set layout to nothing
    def set_layout_to_none
      options[:layout] = false
    end

    # @see FlashResponder
    def set_flash_message
      set_flash_message! if set_flash_message?
    end

    def exception?
      (resource.nil? || resource.is_a?(Exception)) && options[:template] == ERROR_PATH
    end
  end
end

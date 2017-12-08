module Wallaby
  # abstract responder for later usage
  class AbstractResponder < ActionController::Responder
    include ::Responders::FlashResponder

    delegate :params, :headers, to: :request

    def to_html
      # @see FlashResponder
      set_flash_message! if set_flash_message?

      if post? then create_action
      elsif put? || patch? then update_action
      elsif delete? then destroy_action
      else default_render
      end
    end

    def to_csv
      set_layout_to_none
      headers['Content-Type'] = 'text/csv'
      default_render
    end

    def to_json
      set_layout_to_none
      return default_render unless post? || put? || patch? || delete?
      if has_errors? then render :error, options.merge(status: :bad_request)
      else render :form, options
      end
    end

    private

    def create_action
      if has_errors?
        render :new, options
      else
        redirect_to resource_location
      end
    end

    def update_action
      if has_errors?
        render :edit, options
      else
        redirect_to resource_location
      end
    end

    def destroy_action
      redirect_to resource_location
    end

    def file_name
      timestamp = Time.zone.now.to_s(:number)
      "#{params[:resources]}-exported-#{timestamp}.#{format}"
    end

    def set_layout_to_none
      options[:layout] = false
    end
  end
end
